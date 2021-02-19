//
//  NewTripViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 28/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class NewTripViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tripNameTF: UITextField!
    
    @IBOutlet weak var bgCollectionView: UICollectionView!
    
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollVIew: UIScrollView!
    
    @IBOutlet weak var brainstormingDP: UIDatePicker!
    
    @IBOutlet weak var votingDP: UIDatePicker!
    
    
    let db = Firestore.firestore()
    var newTrip: String? = nil
    let df = DateFormatter()
    
    var brainDate: String?
    var votingDate: String?

    var participants: [String] = [] {
        didSet {
            
            DispatchQueue.main.async {
               
                self.tableView.reloadData()
                
                if self.participants.count > 1 {
                    let index = IndexPath(row: self.participants.count, section: 0)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }
                let hConst = self.tableView.frame.height + 44
                self.tableView.removeConstraint(self.tvHeight)
                self.tvHeight = self.tableView.heightAnchor.constraint(equalToConstant: hConst)
                
                self.tvHeight.isActive = true
                self.scrollVIew.setContentOffset(CGPoint(x: self.scrollVIew.contentOffset.x, y: self.scrollVIew.contentOffset.y + 44), animated: true)
            }
            
        }
    }
    
    var backgrounds: [UIImage] = [UIImage(named: "bg1")!, UIImage(named: "bg2")!, UIImage(named: "bg3")!, UIImage(named: "bg4")!]
    var buttonsStates: [Bool] = [false, true, true, true]
    var selectedBG: Int = 1
    
    @IBOutlet weak var tipBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let safeUser = Auth.auth().currentUser {
            self.participants.append(safeUser.email!)
            tripNameTF.autocapitalizationType = .words
        }
        
        // TF delegate
        tripNameTF.delegate = self
        tripNameTF.autocapitalizationType = .words
        tripNameTF.becomeFirstResponder()
        
        tableView.dataSource = self
        tableView.delegate = self
        bgCollectionView.dataSource = self
        bgCollectionView.delegate = self
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: K.newTripAddParticipantsNibName , bundle: nil), forCellReuseIdentifier: K.newTripAddParticipantsCellIdentifier)
        
        tableView.register(UINib(nibName: K.newTripShowParticipantsNibName, bundle: nil), forCellReuseIdentifier: K.newTripShowParticipantsCellIdentifier)
        
        bgCollectionView.register(UINib(nibName: K.bgCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: K.bgCollectionViewCellIdentifier)
        
        
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        
        if UserDefaults.standard.bool(forKey: "tips") == true {
                tipBtn.isHidden = false
            } else {
                tipBtn.isHidden = true
            }
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func tipBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Tip!", message: "You can now give a generic name to your trip and invite a few participants, as well as select a custom background. The brainstorming and voting require an end date selection. If no selection is put through the trip will be automatically titled Upcoming trip and the durations for brainstorming and voting will be one week each.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func handleBrainningDP(_ sender: UIDatePicker) {
        print("IN PICKER")
        print("\(sender.date)")
        brainDate = df.string(from: sender.date)
    }
    
    @IBAction func handleVotingDP(_ sender: UIDatePicker) {
        print("\(sender.date)")
        votingDate = df.string(from: sender.date)
    }
    
    
    
    // Reminder: to create an array of colors to randomize them
    @IBAction func createNewTrip(_ sender: UIButton) {
        
        var tripName: String = tripNameTF.text!
        
        if tripName == ""  {
            print("THry are empty")
            
            let alert = UIAlertController(title: "Warning!", message: "Some fields are empty. Your trip will get default values.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Use Defaults", style: .destructive, handler: { (action) in
                
         
                if tripName == "" {    tripName = "Upcoming trip"}
                
                self.writeNewTripToDB(trip: tripName)
  
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                return
            }))
            self.present(alert,animated: true)
            return
        }
        
        writeNewTripToDB(trip: tripName)
    }
    
    
    func writeNewTripToDB(trip: String) {
        var bgName: String = "bg1"
//        var tripName: String = tripNameTF.text!
        var color: String = K.CorporateColours.teal
        
        let today = Date()
        var finalBrainDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        var finalVotingDate: Date = Calendar.current.date(byAdding: .day, value: 14, to: today)!
        
        
        
        bgName = "bg\(selectedBG)"
        switch selectedBG {
        case 1: color = K.CorporateColours.orange
        case 2: color = K.CorporateColours.brightOrange
        case 3: color = K.CorporateColours.grey
        case 4: color = K.CorporateColours.darkTeal
        default: color = K.CorporateColours.teal
        }
        
        
        if let bD = brainDate {
            finalBrainDate = df.date(from: bD)!
            
        }
        
        if let vD = votingDate {
            finalVotingDate = df.date(from: vD)!
            
        }
        
        guard let user = Auth.auth().currentUser?.email else { return}
        
        var invitees = participants
        invitees.removeFirst(1)
        
        
        
        let  newTripRef = db.collection("trips").document()
        //            print(newTripRef.documentID)
        newTripRef.setData([
            //                    user: FieldValue.serverTimestamp(),
            "bgImage": bgName,
            "calculated": false,
            "color": color,
            "dateAdded": FieldValue.serverTimestamp(),
            "endDate": [
            ],
            "events" : "reference here",
            "leader": user,
            "locations": [
                
            ],
            "name": trip,
            "noParticipants": 1,
            "participants": [
                [
                    "name" : "New User",
                    "email": user
                ]
            ],
            "participantsEmailsArray": [
                user
            ],
            "participantsNamesArray": [
                "New User"
            ],
            "startDate": [
                
            ],
            "tune": [
                
                
            ],
            "status": K.status.brainstormingOpen,
            "brainingDateEnd" : finalBrainDate,
            "votingDateEnd": finalVotingDate,
            "invitees": invitees
            
        ]) { (error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                
            }
        }
        self.newTrip = newTripRef.documentID
        
        let newUserTrip = db.collection("userTrips").document()
        newUserTrip.setData(
            [
                "tripID" : newTripRef.documentID,
                "user": user,
                "dateAdded": FieldValue.serverTimestamp(),
                "bgImage": bgName,
                "color": color,
                "leader": user,
                "name": trip,
                "status": K.status.brainstormingOpen,
                
            ]
        ){ (error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                //
            }
        }
        
        //        Creates the notifications for all the people invited
        for invitee in invitees {
            let newAlert = db.collection("alerts").document()
            newAlert.setData([
                //alert
                "tripID": self.newTrip!,
                "sender": user,
                "tripName": trip,
                "receiver": invitee,
                "alertStatus": K.alert.pending,
                "alertDateAdded": FieldValue.serverTimestamp(),
                "bgImage": bgName,
                "color": color,
                "leader": user,
                "tripStatus": K.status.brainstormingOpen
                
                
            ]) { (error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                }
            }
        }
        
        
        
        DispatchQueue.main.async {
            if  let vc =  self.presentingViewController as? TripsViewController {
                
                vc.tripsCollectionView.reloadData()
                vc.tripsCollectionView.flashScrollIndicators()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - Table view Data source
extension NewTripViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participants.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.newTripAddParticipantsCellIdentifier, for: indexPath) as! NewTripAddParticipantsCell
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.newTripShowParticipantsCellIdentifier, for: indexPath) as! NewTripShowParticipantsCell
        cell.participantTF.text = self.participants[indexPath.row]
        cell.participantTF.isEnabled = false
        
        return cell
    }
    
    
}

//MARK: - TV delegate

extension NewTripViewController: UITableViewDelegate {
 
}

//MARK: - Collection viwe data source
extension NewTripViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.bgCollectionViewCellIdentifier, for: indexPath) as! BGCollectionViewCell
        
        cell.bg.image = backgrounds[indexPath.row]
        cell.bg.layer.cornerRadius = 15.0
        cell.selectedButton.isHidden = buttonsStates[indexPath.row]
        //true maybe?
        return cell
    }
    
    
    
}

//MARK: - COllection view delegate
extension NewTripViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if buttonsStates[indexPath.row] {
            // it is true - is hidden
            buttonsStates[indexPath.row] = false // appears
            selectedBG = indexPath.row + 1
            
            for i in buttonsStates.indices {
                if i != indexPath.row {
                    buttonsStates[i] = true // all others are hidden
                }
            }
        } else {
            // it is false - it appears
            buttonsStates[indexPath.row] = true // is hidden
        }
        
        DispatchQueue.main.async {
            self.bgCollectionView.reloadData()
        }
    }
}


//MARK: - TF Delegate
extension NewTripViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tripNameTF {
            textField.resignFirstResponder()
            // make new participants responder.
            tableView.becomeFirstResponder()
        }
        return true
    }
    
}
