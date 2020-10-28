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
    
    
    let db = Firestore.firestore()
    var newTrip: String? = nil
    
    // so must make tv and do select for collection view and then submit
    
    // image picker
//
//    let imagePicker = UIImagePickerController()
//    imagePicker.delegate = self
//    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//    imagePicker.allowsEditing = false
//    self.present(imagePicker, animated: true, completion: nil)
    
    
    
    
//    var participants: [String] = ["user1@gmail.com", "user2@gmail.com", "Mariaaaa", "you've got to see heeer", "user1@gmail.com", "user2@gmail.com", "Mariaaaa", "you've got to see heeer"]
    
     var participants: [String] = [] {
        didSet {
            
            DispatchQueue.main.async {
                print("i am in did set")
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
    var selectedBG: Int? = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let safeUser = Auth.auth().currentUser {
            self.participants.append(safeUser.email!)
        }
        
        // TF delegate
        tripNameTF.delegate = self
    
        tableView.dataSource = self
        tableView.delegate = self
        bgCollectionView.dataSource = self
        bgCollectionView.delegate = self
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: K.newTripAddParticipantsNibName , bundle: nil), forCellReuseIdentifier: K.newTripAddParticipantsCellIdentifier)
        
        tableView.register(UINib(nibName: K.newTripShowParticipantsNibName, bundle: nil), forCellReuseIdentifier: K.newTripShowParticipantsCellIdentifier)
        
        bgCollectionView.register(UINib(nibName: K.bgCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: K.bgCollectionViewCellIdentifier)
  
    }
    

    @IBAction func createNewTrip(_ sender: UIButton) {
        
        
        // this must really check for not empty or maybe do an update instead of create not sure
        // NAME can stay as upcoming trip?
        // votes munst be removeed
        
        var bgName: String = "bg1"
        var tripName: String = tripNameTF.text!
        
        if let safeBG = selectedBG {
            
             bgName = "bg" + String(describing: safeBG)
        } else {
            // NO bg selected - inform user
             
        }
            
            if tripNameTF.text == "" {
                 tripName = "Upcoming trip"
            }
            
        if let user = Auth.auth().currentUser?.email {
                let newTripRef = db.collection("trips").document()
        //            print(newTripRef.documentID)
                newTripRef.setData([
                    "bgImage": bgName,
                    "calculated": false,
                    "color": "BrandOrange",
                    "dateAdded": FieldValue.serverTimestamp(),
                    "endDate": [
                    ],
                     "events" : "reference here",
                     "leader": user,
                     "locations": [
        
                     ],
                    "name":
                        [
                            [
                                "name" : tripName,
                                "votes": 0,
                                "voters": []
                            ]
                    ],
        
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
        
        
                    ]
                ]) { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        self.newTrip = newTripRef.documentID
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
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
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.newTripShowParticipantsCellIdentifier, for: indexPath) as! NewTripShowParticipantsCell
            cell.participantTF.text = self.participants[indexPath.row]
            cell.participantTF.tintColor = UIColor.systemGray
            cell.participantTF.isEnabled = false
//            cell.participantTF.borderStyle = .none
            return cell
        }
        
            let cell = tableView.dequeueReusableCell(withIdentifier: K.newTripShowParticipantsCellIdentifier, for: indexPath) as! NewTripShowParticipantsCell
        cell.participantTF.text = self.participants[indexPath.row]
//        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            return cell
        
        
        
       
    }
    
    
}

//MARK: - TV delegate

extension NewTripViewController: UITableViewDelegate {
// dont know man
}

//MARK: - Collection viwe data source
extension NewTripViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.bgCollectionViewCellIdentifier, for: indexPath) as! BGCollectionViewCell
        
        cell.bg.image = backgrounds[indexPath.row]
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
                   buttonsStates[i] = true // all other are hidden
                }
            }
        } else {
            // it is false - it appears
            buttonsStates[indexPath.row] = true // is hidden
            selectedBG = nil
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
