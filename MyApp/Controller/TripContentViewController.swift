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
    
    
    var selectedTrip: String? {
        didSet {
            read()
        }
    }
    
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    var timer: Timer?
    
    var currentTrip: Trip?
    var noParticipants: Int?
    var sections: [TripSection] = []
    let db = Firestore.firestore()
    var sectionsTest: [TripSection] = []
    
    //    TIMERS
    var timerDate: Date?
    var timerDateString: String?
    let df = DateFormatter()
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MUST BE REMOVED if location is not implemented
        if let destinationVC = segue.destination as? TripLocationViewController {
            destinationVC.test =  TripContentAddLocationCell.valueForSegue
            
        } else if let destinationVC = segue.destination as? TripVotedViewController {
            //            self.navigationController?.popViewController(animated: true)
            destinationVC.selectedTrip = selectedTrip!
            print("printing destination sel trip\(destinationVC.selectedTrip!)")
        } else if let destinationVC = segue.destination as? NotesViewController {
            destinationVC.selectedTrip = selectedTrip!
        }
        if let destinationVC = segue.destination as? AddParticipantsModalViewController {
            destinationVC.selectedTrip = selectedTrip!
        }
    }
    
    override func viewDidLoad() {
        print("VIEW DID LOAD")
        super.viewDidLoad()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        //Populate table view, source table view, set up cell xib
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.tripContentAddNibName, bundle: nil), forCellReuseIdentifier: "AddReusableCell")
        // show cell
        tableView.register(UINib(nibName: K.tripContentShowNibName, bundle: nil), forCellReuseIdentifier: K.tripContentCellIdentifier)
        // all add cells
        tableView.register(UINib(nibName: K.tripContentAddLocationNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddLocationCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddTuneNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddTuneCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddStartDateNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddStartDateCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddEndDateNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddEndDateCellIdentifier)
        tableView.register(UINib(nibName: K.tripContentAddNameNibName , bundle: nil), forCellReuseIdentifier: K.tripContentAddNameCellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        
        if selectedTrip == nil {
            navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @IBAction func addParticipantTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.contentToAddPeopleModal, sender: self)
    }
    
    
    @objc func fireTimer() {
        
        let currentDate = Date()
        let elapsedTime = timerDate!.timeIntervalSince(currentDate)
        var labelEnding = ""
        if currentTrip?.status == K.status.votingOpen {
            labelEnding = "vote"
        } else if currentTrip?.status == K.status.brainstormingOpen {
            labelEnding = "submit proposals"
        }
        timerLabel.text = "You have \(Int(ceil(elapsedTime/3600/24))) days left to \(labelEnding)"
        // Run calculate method when interval runs out
        if elapsedTime <= 0 {
            calculate(calculateBtn)
        }
    }
    
    @IBAction func addNewParticipant(_ sender: UIBarButtonItem) {
        
    }
    
    
    func read() {
        print("LOAD function")
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
                
                
                // Sets up the current trip and the calculate buttons, as well as the timer
                if let name = data["name"] as? String, let bgImage = data["bgImage"] as? String, let color = data["color"] as? String,  let status = data["status"] as? String, let leader = data["leader"] as? String {
                    if let finalImage = UIImage(named: bgImage), let finalColor = UIColor(named: color), let p = data["noParticipants"] as? Int {
                        DispatchQueue.main.async {
                            self.currentTrip = Trip(id: document.documentID, title: name, bgImage: finalImage, color: finalColor, status: status, leader: leader)
                            self.noParticipants = p
                            
                            if self.currentTrip?.leader != user {
                                print("NOT THE SAME PERSON LEADER AND CURRENT")
                                self.calculateBtn.isEnabled = false
                                self.calculateBtn.isHidden = true 
                            } else {
                                print("SAME PERSON LEADER AND CURRENT")
                            }
                            // Status
                            if self.currentTrip!.status == K.status.brainstormingOpen {
                                
                                if let timestamp =  data["brainingDateEnd"] as? Timestamp {
                                    self.timerDateString = self.df.string(from: timestamp.dateValue())
                                    self.timerDate = timestamp.dateValue()
                                    
                                }
                                self.calculateBtn.setTitle("Go to voting stage", for: .normal)
                            }
                            else if self.currentTrip!.status == K.status.votingOpen {
                                if let timestamp =  data["votingDateEnd"] as? Timestamp {
                                    self.timerDateString = self.df.string(from: timestamp.dateValue())
                                    self.timerDate = timestamp.dateValue()
                                }
                                self.calculateBtn.setTitle("Calculate", for: .normal)
                            }
                            
                        }
                    }
                }
                
                
                //              Appends all the sections
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
                
                //                let df = DateFormatter()
                self.df.dateFormat = "dd MMM yyyy"
                
                self.sections.append(TripSection(sectionTitle: "Start Date", open: true, cellData: []))
                if let dates = data["startDate"] as? Array<Any> {
                    self.sections[2].cellData = []
                    for date in dates {
                        if let d = date as? Dictionary<String, Any> {
                            
                            if let timestamp =  d["date"] as? Timestamp {
                                let timestampToDate = self.df.string(from: timestamp.dateValue())
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
                if let endDates = data["endDate"] as? Array<Any> {
                    self.sections[3].cellData = []
                    for endDate in endDates {
                        if let endD = endDate as? Dictionary<String, Any> {
                            if let timestamp =  endD["date"] as? Timestamp {
                                let timestampToDate = self.df.string(from: timestamp.dateValue())
                                alreadyVoted = false
                                if let voters = endD["voters"] as? Array<String> {
                                    if voters.contains(user!) {
                                        alreadyVoted = true
                                    }
                                }
                                let tc =  TripCell(itemTitle: nil, itemContent: timestampToDate, itemImage: "calendar", stats: endD["votes"] as! Int, alreadyVoted: alreadyVoted)
                                self.sections[3].cellData.append(tc)
                            }
                        }
                    }
                }
                
                self.sections.append(TripSection(sectionTitle: "Notes", open: true, cellData: []))
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    
    
    @IBAction func calculate(_ sender: UIButton) {
        if currentTrip?.status == K.status.votingOpen{
            currentTrip?.status = K.status.votingClosed
            self.calculateWriteToDB()
        }
        
        else if currentTrip?.status == K.status.brainstormingOpen {
            
            // Calculate button set up
            currentTrip?.status = K.status.votingOpen
            calculateBtn.setTitle("Calculate", for: .normal)
            
            
            // Write to DB
            let t = db.collection("trips").document(selectedTrip!)
            t.updateData([
                "status": K.status.votingOpen
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            // user trips
            db.collection("userTrips").whereField("tripID", isEqualTo: selectedTrip!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            let ref = document.documentID
                            let t = self.db.collection("userTrips").document(ref)
                            t.updateData([
                                "status": K.status.votingOpen
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        }
                    }
                }// end
        }
    }
    
    
    
    func calculateWriteToDB() {
        let sfReference = db.collection("trips").document(selectedTrip!)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let data = sfDocument.data() else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            self.df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
            var finalLocation = ""
            var maxLocationVotes = 0
            
            if let locations = data["locations"] as? Array<Any> {
                for location in locations {
                    if let l = location as? Dictionary<String, Any> {
                        let locationVotes = l["votes"] as! Int
                        if locationVotes > maxLocationVotes {
                            maxLocationVotes = locationVotes
                            finalLocation = l["name"] as! String
                        }
                    }
                }
            } else {
                print("error with location")
            }
            
            var finalTune = ""
            var maxTuneVotes = 0
            
            if let tunes = data["tune"] as? Array<Any> {
                for tune in tunes {
                    if let t = tune as? Dictionary<String, Any> {
                        let tuneVotes = t["votes"] as! Int
                        if tuneVotes > maxTuneVotes {
                            maxTuneVotes = tuneVotes
                            finalTune = t["name"] as! String
                        }
                    }
                }
            } else {
                print("error with tune")
            }
            
            var finalStartDate:Timestamp?
            var maxStartDateVotes = 0
            
            if let startDates = data["startDate"] as? Array<Any> {
                for date in startDates {
                    if let d = date as? Dictionary<String, Any> {
                        let startDateVotes = d["votes"] as! Int
                        if startDateVotes > maxStartDateVotes {
                            maxStartDateVotes = startDateVotes
                            finalStartDate = d["date"] as? Timestamp
                        }
                    }
                }
            } else {
                print("error with tune")
            }
            
            var finalEndDate: Timestamp?
            let maxEndDateVotes = 0
            
            if let endDates = data["endDate"] as? Array<Any> {
                for date in endDates {
                    if let d = date as? Dictionary<String, Any> {
                        let endDateVotes = d["votes"] as! Int
                        if endDateVotes > maxEndDateVotes {
                            maxStartDateVotes = endDateVotes
                            finalEndDate = d["date"] as? Timestamp
                        }
                    }
                }
            } else {
                print("error with tune")
            }
            
            
            transaction.updateData(["votedLocation": finalLocation, "votedTune": finalTune, "votedStartDate": finalStartDate as Any, "votedEndDate": finalEndDate as Any, "status": K.status.votingClosed], forDocument: sfReference)
            return [finalLocation, finalTune, finalStartDate as Any, finalEndDate as Any]
            
        }) { (object, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.performSegue(withIdentifier: K.openToVoted, sender: self)
                
                // user trips
                self.db.collection("userTrips").whereField("tripID", isEqualTo: self.selectedTrip!)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                
                                let ref = document.documentID
                                let t = self.db.collection("userTrips").document(ref)
                                t.updateData([
                                    "status": K.status.votingClosed
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                            }
                        }
                    }// end
            }
        }
    }
}
//MARK: - Table view data source
extension TripContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel()
        titleLabel.text = sections[section].sectionTitle
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.backgroundColor = .clear
        return titleLabel
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return 1
        } else {
            if currentTrip?.status == K.status.brainstormingOpen {
                return sections[section].cellData.count + 1
            }
            else {
                //                if section == 0 {
                // voring open
                if sections[section].cellData.count == 0 {
                    return sections[section].cellData.count + 1
                } else {
                    return sections[section].cellData.count
                }
                //                } else {
                //                    return sections[section].cellData.count
                //                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if currentTrip?.status == K.status.brainstormingOpen && indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddLocationCellIdentifier, for: indexPath) as! TripContentAddLocationCell
                cell.addTF.placeholder = "New location"
                cell.goButton.isHidden = true
                cell.selectionStyle = .none
                return cell
            } else {
                // voting open
                // no rows
                if sections[indexPath.section].cellData.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = TripCell(itemTitle: nil, itemContent: "This item has no proposals.", itemImage: "mappin.slash", stats: 0, alreadyVoted: true)
                    cell.itemImage.image = UIImage(systemName: data.itemImage ?? "person" )
                    //                    cell.itemImage.tintColor = UIColor(named: K.CorporateColours.brightOrange)
                    //                    cell.itemContentLabel.textColor = UIColor(named: K.CorporateColours.brightOrange)
                    cell.itemContentLabel.text = "\(data.itemContent ?? "")"
                    
                    cell.selectionStyle = .none
                    cell.statsLabel.isHidden = true
                    cell.voteBtn.isHidden = true
                    return cell
                    
                }
                else {
                    // there are rows
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = sections[indexPath.section].cellData[indexPath.row]
                    
                    
                    cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                    cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                    
                    cell.selectionStyle = .none
                    
                    if currentTrip?.status == K.status.votingOpen {
                        cell.voteBtn.isHidden = false
                        cell.statsLabel.isHidden = false
                        cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                        if data?.alreadyVoted == true {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        } else {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                        }
                    } else   {
                        cell.voteBtn.isHidden = true
                        cell.statsLabel.isHidden = true
                    }
                    return cell
                }
            } // end else
        }
        
        if indexPath.section == 1 {
            if currentTrip?.status == K.status.brainstormingOpen && indexPath.row == tableView.numberOfRows(inSection: 1) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddTuneCellIdentifier, for: indexPath) as! TripContentAddTuneCell
                // must make the text differrent per section, also add buttons.
                cell.addTF.placeholder = "New tune"
                cell.goButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                cell.goButton.isHidden = true
                cell.selectionStyle = .none
                return cell
            } else  {
                // voting open
                // no rows
                if sections[indexPath.section].cellData.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = TripCell(itemTitle: nil, itemContent: "This item has no proposals.", itemImage: "mic.slash.fill", stats: 0, alreadyVoted: true)
                    cell.itemImage.image = UIImage(systemName: data.itemImage ?? "person" )
                    cell.itemContentLabel.text = "\(data.itemContent ?? "")"
                    cell.selectionStyle = .none
                    cell.statsLabel.isHidden = true
                    cell.voteBtn.isHidden = true
                    return cell
                    
                }
                else {
                    // there are rows
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = sections[indexPath.section].cellData[indexPath.row]
                    cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                    cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                    
                    cell.selectionStyle = .none
                    if currentTrip?.status == K.status.votingOpen {
                        cell.voteBtn.isHidden = false
                        cell.statsLabel.isHidden = false
                        cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                        if data?.alreadyVoted == true {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        } else {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                        }
                    } else   {
                        cell.voteBtn.isHidden = true
                        cell.statsLabel.isHidden = true
                    }
                    return cell
                }
            }
        }// end section 1
        
        if indexPath.section == 2 {
            if currentTrip?.status == K.status.brainstormingOpen && indexPath.row == tableView.numberOfRows(inSection: 2) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddStartDateCellIdentifier, for: indexPath) as! TripContentAddStartDateCell
                cell.selectionStyle = .none
                return cell
            } else {
                // voting open
                // no rows
                if sections[indexPath.section].cellData.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = TripCell(itemTitle: nil, itemContent: "This item has no proposals.", itemImage: "calendar.badge.minus", stats: 0, alreadyVoted: true)
                    cell.itemImage.image = UIImage(systemName: data.itemImage ?? "person" )
                    cell.itemContentLabel.text = "\(data.itemContent ?? "")"
                    cell.selectionStyle = .none
                    cell.statsLabel.isHidden = true
                    cell.voteBtn.isHidden = true
                    return cell
                    
                }
                else {
                    // there are rows
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = sections[indexPath.section].cellData[indexPath.row]
                    cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                    cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                    
                    cell.selectionStyle = .none
                    if currentTrip?.status == K.status.votingOpen {
                        cell.voteBtn.isHidden = false
                        cell.statsLabel.isHidden = false
                        cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                        if data?.alreadyVoted == true {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        } else {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                        }
                    } else   {
                        cell.voteBtn.isHidden = true
                        cell.statsLabel.isHidden = true
                    }
                    return cell
                }
            }
        }
        if indexPath.section == 3 {
            if currentTrip?.status == K.status.brainstormingOpen && indexPath.row == tableView.numberOfRows(inSection: 3) - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentAddEndDateCellIdentifier, for: indexPath) as! TripContentAddEndDateCell
                cell.selectionStyle = .none
                return cell
            } else  {
                // voting open
                // no rows
                if sections[indexPath.section].cellData.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = TripCell(itemTitle: nil, itemContent: "This item has no proposals.", itemImage: "calendar.badge.minus", stats: 0, alreadyVoted: true)
                    cell.itemImage.image = UIImage(systemName: data.itemImage ?? "person" )
                    cell.itemContentLabel.text = "\(data.itemContent ?? "")"
                    cell.selectionStyle = .none
                    cell.statsLabel.isHidden = true
                    cell.voteBtn.isHidden = true
                    return cell
                    
                }
                else {
                    // there are rows
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.tripContentCellIdentifier, for: indexPath) as! TripContentShowCell
                    let data = sections[indexPath.section].cellData[indexPath.row]
                    cell.itemImage.image = UIImage(systemName: data?.itemImage ?? "person" )
                    cell.itemContentLabel.text = "\(data?.itemContent ?? "")"
                    
                    cell.selectionStyle = .none
                    if currentTrip?.status == K.status.votingOpen {
                        cell.voteBtn.isHidden = false
                        cell.statsLabel.isHidden = false
                        cell.statsLabel.text = String(describing: data!.stats)+"/"+"\(String(describing: noParticipants!))"
                        if data?.alreadyVoted == true {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        } else {
                            cell.voteBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                        }
                    } else   {
                        cell.statsLabel.isHidden = true
                        cell.voteBtn.isHidden = true
                    }
                    return cell
                }
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
        
        let cell = UITableViewCell()
        return cell
        
    }
    
}
//MARK: - Table view delegate
extension TripContentViewController: UITableViewDelegate {
    
}

