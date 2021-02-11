//
//  StandardNewTripViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 23/01/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//


import UIKit
import Firebase

class StandardNewTripViewController: UIViewController {

 
    @IBOutlet weak var tripNameTF: UITextField!
    
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var tuneTF: UITextField!
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var scrollVIew: UIScrollView!
    @IBOutlet weak var startDP: UIDatePicker!
    @IBOutlet weak var endDP: UIDatePicker!
    

    let df = DateFormatter()
    let db = Firestore.firestore()
    var newTrip: String? = nil

    var brainDate: String?
    var votingDate: String?
    
    
    var backgrounds: [UIImage] = [UIImage(named: "bg1")!, UIImage(named: "bg2")!, UIImage(named: "bg3")!, UIImage(named: "bg4")!]
    var buttonsStates: [Bool] = [false, true, true, true]
    var selectedBG: Int = 1
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        tripNameTF.autocapitalizationType = .words
        locationTF.autocapitalizationType = .words
        tuneTF.autocapitalizationType = .words
        tripNameTF.becomeFirstResponder()
     
        // TF delegate
        tripNameTF.delegate = self
        locationTF.delegate = self
        tuneTF.delegate = self
    
        colView.dataSource = self
        colView.delegate = self
        // Do any additional setup after loading the view.
        
        colView.register(UINib(nibName: K.bgCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: K.bgCollectionViewCellIdentifier)
  
        
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }


    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       if let destinationVC = segue.destination as? TripVotedViewController {
//            destinationVC.selectedTrip = newTrip
//
//        }
//    }
    
    @IBAction func handleBrainningDP(_ sender: UIDatePicker) {
        print("IN PICKER")
        print("\(sender.date)")
        brainDate = df.string(from: sender.date)
    }
    
    @IBAction func handleVotingDP(_ sender: UIDatePicker) {
        print("\(sender.date)")
        votingDate = df.string(from: sender.date)
    }
    
    // must create an array of colors to randomize them
    @IBAction func createNewTrip(_ sender: UIButton) {
        
        var tripName: String = tripNameTF.text!
        var tuneName: String = tuneTF.text!
        var locationName: String = locationTF.text!
        
        if tripName == "" || tuneName == "" || locationName == ""  {
            print("THry are empty")
            
            let alert = UIAlertController(title: "Warning!", message: "Some fields are empty. Your trip will get default values.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Use Defaults", style: .destructive, handler: { (action) in
                
         
                if tripName == "" {tripName = "Upcoming trip"}
                if tuneName == "" {     tuneName = "Queen - I want to break free"}
                if locationName == "" { locationName = "London"}
                
                self.writeNewTripToDB(trip: tripName, tune: tuneName, loc: locationName)
  
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                return
            }))
            self.present(alert,animated: true)
            return
        }
        
        writeNewTripToDB(trip: tripName, tune: tuneName, loc: locationName)
        
   
        }
    
    func writeNewTripToDB (trip: String, tune: String, loc: String) {
        
        var bgName: String = "bg1"
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
  
        
        if let bD = self.brainDate {
            finalBrainDate = self.df.date(from: bD)!
            
        }
        print(finalBrainDate)
        if let vD = self.votingDate {
            finalVotingDate = self.df.date(from: vD)!
          
        }
        print(finalVotingDate)
        guard let user = Auth.auth().currentUser?.email else { return}
        
   
       
        let  newTripRef = self.db.collection("trips").document()
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
                     "leader": "N/A",
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
                    "status": K.status.votingClosed,
//                    "brainingDateEnd" : finalBrainDate,
//                    "votingDateEnd": finalVotingDate,
                    "invitees": [],
                    "votedLocation" : loc,
                    "votedTune": tune,
                    "votedStartDate": finalBrainDate,
                    "votedEndDate": finalVotingDate
                    
                ]) { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        
                    }
                }
        self.newTrip = newTripRef.documentID

        let newUserTrip = self.db.collection("userTrips").document()
        newUserTrip.setData(
            [
                "tripID" : newTripRef.documentID,
                "user": user,
                "dateAdded": FieldValue.serverTimestamp(),
                "bgImage": bgName,
                "color": color,
                 "leader": "N/A",
                "name": trip,
                "status": K.status.votingClosed,
                
            ]
        ){ (error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                //
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


//MARK: - Collection viwe data source
extension StandardNewTripViewController: UICollectionViewDataSource {
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
extension StandardNewTripViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if buttonsStates[indexPath.row] {
            // it is true - is hidden
            buttonsStates[indexPath.row] = false // appears
            selectedBG = indexPath.row + 1
            
            for i in buttonsStates.indices {
                if i != indexPath.row {
                   buttonsStates[i] = true // all other are hidden
                }
            }
        } else {
            // it is false - it appears
            buttonsStates[indexPath.row] = true // is hidden
//            selectedBG = nil
        }
        
                DispatchQueue.main.async {
                    self.colView.reloadData()
                    
                }
       
    }
    
}


//MARK: - TF Delegate
extension StandardNewTripViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tripNameTF {
            textField.resignFirstResponder()
            // make new participants responder.
            locationTF.becomeFirstResponder()
        }
        if textField == locationTF {
            locationTF.resignFirstResponder()
            tuneTF.becomeFirstResponder()
        }
        if textField == tuneTF {
            tuneTF.resignFirstResponder()
            colView.becomeFirstResponder()
        }
        return true
    }
    
}
