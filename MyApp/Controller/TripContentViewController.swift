//
//  TripContentViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 01/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import MapKit
import Firebase




// must see how 

class TripContentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // use array to store tf values???????????????????????????????
    var selectedTrip: String? {
        // set to nil for new trip?
       
        didSet {
            print("i am in content setting trip")
            read()
        }
    }
    
    var currentTrip: Trip?
    var noParticipants: Int?
    var sections: [TripSection] = []
    let db = Firestore.firestore()
    var sectionsTest: [TripSection] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TripLocationViewController {
            
            destinationVC.test =  TripContentAddLocationCell.valueForSegue
        } else if let destinationVC = segue.destination as? TripVotedViewController {
            print("i am called before segue")
            destinationVC.selectedTrip = selectedTrip!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        
        //Populate table view, source table view, set up cell xib
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.tripContentAddNibName, bundle: nil), forCellReuseIdentifier: "AddReusableCell")
        // show cell
        tableView.register(UINib(nibName: K.tripContentShowNibName, bundle: nil), forCellReuseIdentifier: K.tripContentCellIdentifier)
        // all add cells
//        tableView.register(UINib(nibName: K.tripContentAddParticipantsNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddParticipantsCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddLocationNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddLocationCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddTuneNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddTuneCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddStartDateNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddStartDateCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddEndDateNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddEndDateCellIdentifier)
         tableView.register(UINib(nibName: K.tripContentAddNameNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddNameCellIdentifier)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    // or just use segue?
    @IBAction func addNewParticipant(_ sender: UIBarButtonItem) {
        
    }
    
    
    func read() {
        
        // must unwrap optional for selected trip
        db.collection("trips").document(selectedTrip!)
            .addSnapshotListener { documentSnapshot, error in
                self.sections = []
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                // top be used below
                let user = Auth.auth().currentUser?.email
                 var alreadyVoted: Bool = false
        if let names = data["name"] as? Array<Any> {
            var title = ""
            if names.count > 0 {
                if let n = names[0] as? Dictionary<String, Any> {
                    title = n["name"] as! String
                }
            } else {
                 title = "Upcoming trip"
            }
                
                if let bgImage = data["bgImage"] as? String, let color = data["color"] as? String {
                    print("------------ setting current trip and ")
                    
                    if let finalImage = UIImage(named: bgImage), let finalColor = UIColor(named: color), let p = data["noParticipants"] as? Int {
                self.currentTrip = Trip(id: document.documentID, title: title, bgImage: finalImage, color: finalColor)
                self.noParticipants = p
                    }
                    }
                }
                
//                self.sections.append(TripSection(sectionTitle: "Trip Code Name", open: true, cellData: []))
//
//                if let names = data["name"] as? Array<Any> {
//                    self.sections[0].cellData = []
//                    for name in names {
//                        if let n = name as? Dictionary<String, Any> {
//                            alreadyVoted = false
//                            if let voters = n["voters"] as? Array<String> {
//                                if voters.contains(user!) {
//                                    alreadyVoted = true
//                                }
//                            }
//                            let tc =  TripCell(itemTitle: nil, itemContent: n["name"] as! String, itemImage: "person", stats: n["votes"] as! Int, alreadyVoted: alreadyVoted)
//                            self.sections[0].cellData.append(tc)
//                        }
//                    }
//                }else {
//                    print("error with name")
//                }
//
//
//                self.sections.append(TripSection(sectionTitle: "Participants", open: true, cellData: []))
//
//                if let participants = data["participants"] as? Array<Any> {
//                    self.sections[1].cellData = []
//                    for participant in participants {
//                        if let p = participant as? Dictionary<String, Any> {
//                            alreadyVoted = false
//                                                       if let voters = p["voters"] as? Array<String> {
//                                                           if voters.contains(user!) {
//                                                               alreadyVoted = true
//                                                           }
//                                                       }
//                            let tc =  TripCell(itemTitle: nil, itemContent: p["name"] as! String, itemImage: "person", stats: 0, alreadyVoted: alreadyVoted)
//                            // participants dont have votes!!!!!
//                            self.sections[1].cellData.append(tc)
//                        }
//                    }
//                }else {
//                    print("error with participants")
//                }
                
                self.sections.append(TripSection(sectionTitle: "Location", open: true, cellData: []))
                self.sections[0].cellData = []
                if let locations = data["locations"] as? Array<Any> {
                    for location in locations {
                        if let l = location as? Dictionary<String, Any> {
                            alreadyVoted = false
                                                                                  if let voters = l["voters"] as? Array<String> {
                                                                                      if voters.contains(user!) {
                                                                                          alreadyVoted = true
                                                                                      }
                                                                                  }
                            let tc =  TripCell(itemTitle: nil, itemContent: l["name"] as! String, itemImage: "map", stats: l["votes"] as! Int, alreadyVoted: alreadyVoted)
                            self.sections[0].cellData.append(tc)
                            
                        }
                    }
                } else {
                    print("error with location")
                }
                
                self.sections.append(TripSection(sectionTitle: "Tune", open: true, cellData: []))
                
                if let tunes = data["tune"] as? Array<Any> {
                    self.sections[1].cellData = []
                    for tune in tunes {
                        if let t = tune as? Dictionary<String, Any> {
                            alreadyVoted = false
                                                                                  if let voters = t["voters"] as? Array<String> {
                                                                                      if voters.contains(user!) {
                                                                                          alreadyVoted = true
                                                                                      }
                                                                                  }
                            let tc =  TripCell(itemTitle: nil, itemContent: t["name"] as! String, itemImage: "music.mic", stats: t["votes"] as! Int, alreadyVoted: alreadyVoted)
                            self.sections[1].cellData.append(tc)
                            
                        }
                    }
                } else {
                    print("error with tune")
                }
                
                // Date formatter set up
                let df = DateFormatter()
                df.dateFormat = "dd-MM-yyyy"
                
                self.sections.append(TripSection(sectionTitle: "Start Date", open: true, cellData: []))
                
                if let dates = data["startDate"] as? Array<Any> {
                    self.sections[2].cellData = []
                    for date in dates {
                        if let d = date as? Dictionary<String, Any> {
                            
                            if let timestamp =  d["date"] as? Timestamp {
                                let timestampToDate = df.string(from: timestamp.dateValue())
                                alreadyVoted = false
                                                                                      if let voters = d["voters"] as? Array<String> {
                                                                                          if voters.contains(user!) {
                                                                                              alreadyVoted = true
                                                                                          }
                                                                                      }
                                let tc =  TripCell(itemTitle: nil, itemContent: timestampToDate, itemImage: "calendar", stats: d["votes"] as! Int, alreadyVoted: alreadyVoted)
                                self.sections[2].cellData.append(tc)
                                
                            }
                        }
                    }
                }
                
                self.sections.append(TripSection(sectionTitle: "End Date", open: true, cellData: []))
                
                if let dates = data["endDate"] as? Array<Any> {
                    self.sections[3].cellData = []
                    for date in dates {
                        if let d = date as? Dictionary<String, Any> {
                            if let timestamp =  d["date"] as? Timestamp {
                                let timestampToDate = df.string(from: timestamp.dateValue())
                                alreadyVoted = false
                                                                                      if let voters = d["voters"] as? Array<String> {
                                                                                          if voters.contains(user!) {
                                                                                              alreadyVoted = true
                                                                                          }
                                                                                      }
                                let tc =  TripCell(itemTitle: nil, itemContent: timestampToDate, itemImage: "calendar", stats: d["votes"] as! Int)
                                self.sections[3].cellData.append(tc)
                            }
                        }
                    }
                }
//                self.sections.append(TripSection(sectionTitle: "Trip Theme", open: true, cellData: []))
//                self.sections.append(TripSection(sectionTitle: "Accommodation", open: true, cellData: []))
                self.sections.append(TripSection(sectionTitle: "Notes", open: true, cellData: []))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        performSegue(withIdentifier: K.openToVoted, sender: sender)
    }
}
//MARK: - Table view data source

extension TripContentViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let titleLabel = UILabel()
        titleLabel.text = sections[section].sectionTitle
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.backgroundColor = .white
        
//        if section == 6 {
//            let goButton = UIButton()
//            goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//            goButton.tintColor = UIColor(named: K.CorporateColours.orange)
//            let stack = UIStackView(arrangedSubviews: [titleLabel, goButton])
////            goButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 25).isActive = true
//            return stack
//        }
        
        return titleLabel
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("printing sections")
//        print("rows for section", section, " is ", sections[section].cellData.count + 1)
        return sections[section].cellData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0 {
//            if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddNameCellIdentifier, for: indexPath) as! TripContentAddNameCell
//                cell.addTF.placeholder = "Enter trip code name"
//                cell.selectionStyle = .none
//                cell.goButton.isHidden = true
////                cell.goButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
//
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
//                let data = sections[indexPath.section].cellData[indexPath.row]
//                cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "quote.bubble" )
//                cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
//                cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
//                cell.voteBtn.isHidden = false
//                if data?.alreadyVoted == true {
//                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//                } else {
//                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//                }
//                cell.selectionStyle = .none
//                return cell
//            }
//        }
//        if indexPath.section == 1 {
//            if indexPath.row == tableView.numberOfRows(inSection: 1) - 1 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddParticipantsCellIdentifier, for: indexPath) as! TripContentAddParticipantsCell
//                cell.addTF.placeholder = "Enter email or phone number"
//                cell.selectionStyle = .none
//                cell.goButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
//
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
//                let data = sections[indexPath.section].cellData[indexPath.row]
//                cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
//                cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
//                cell.statsLabel.text = ""
//                cell.voteBtn.isHidden = true
//                cell.selectionStyle = .none
//                return cell
//            }
//        }
        if indexPath.section == 0 {
            if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddLocationCellIdentifier, for: indexPath) as! TripContentAddLocationCell
                // must make the text differrent per section, also add buttons.
                cell.addTF.placeholder = "New location"
//                cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                cell.goButton.isHidden = true
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                let data = sections[indexPath.section].cellData[indexPath.row]
                
                
                cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                cell.selectionStyle = .none
                if data?.alreadyVoted == true {
                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                } else {
                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                }
                return cell
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == tableView.numberOfRows(inSection: 1) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddTuneCellIdentifier, for: indexPath) as! TripContentAddTuneCell
                // must make the text differrent per section, also add buttons.
                cell.addTF.placeholder = "New tune"
                cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                cell.goButton.isHidden = true
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                let data = sections[indexPath.section].cellData[indexPath.row]
                //                cell.itemTitleLabel.text = "Ma cac "
                cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                cell.selectionStyle = .none
                if data?.alreadyVoted == true {
                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                } else {
                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                }
                return cell
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == tableView.numberOfRows(inSection: 2) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddStartDateCellIdentifier, for: indexPath) as! TripContentAddStartDateCell
                cell.addTF.placeholder = "New date"
                cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                cell.goButton.isHidden = true
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                let data = sections[indexPath.section].cellData[indexPath.row]
                cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                cell.voteBtn.isHidden  = false
                cell.selectionStyle = .none
                if data?.alreadyVoted == true {
                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                } else {
                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                }
                return cell
            }
        }
        
        if indexPath.section == 3 {
            if indexPath.row == tableView.numberOfRows(inSection: 3) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddEndDateCellIdentifier, for: indexPath) as! TripContentAddEndDateCell
                cell.addTF.placeholder = "New date"
                cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                cell.goButton.isHidden = true
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                let data = sections[indexPath.section].cellData[indexPath.row]
                cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                cell.voteBtn.isHidden  = false
                cell.selectionStyle = .none
                if data?.alreadyVoted == true {
                    cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
                return cell
            }
        }
        
        if indexPath.section == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddReusableCell", for: indexPath) as! TripContentAddCell
            // must make the text differrent per section, also add buttons.
            cell.addTF.text = "Go to Notes"
            cell.addTF.isEnabled = false
            cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            cell.goButton.isHidden = false
            cell.selectionStyle = .none
            return cell
            
        }
        
        // NOT NEEDED ANYMORE
        if indexPath.section == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddReusableCell", for: indexPath) as! TripContentAddCell
            // must make the text differrent per section, also add buttons.
            cell.addTF.text = "Go to Accommodation"
            cell.addTF.isEnabled = false
            cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            cell.goButton.isHidden = false
            cell.selectionStyle = .none
            return cell
            
        }
        
        if indexPath.section == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddReusableCell", for: indexPath) as! TripContentAddCell
            // must make the text differrent per section, also add buttons.
            cell.addTF.text = "Go to Notes"
            cell.addTF.isEnabled = false
            cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            cell.goButton.isHidden = false
            cell.selectionStyle = .none
            return cell
            
        }
        let cell = UITableViewCell()
        return cell
        
    }
    
}
//MARK: - Table view delegate
extension TripContentViewController: UITableViewDelegate {
    
}

