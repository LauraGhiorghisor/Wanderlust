//
//  TripCollectionViewCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 23/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
//import FirebaseFirestore
import Firebase

class TripCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var statsLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    let db = Firestore.firestore()
    var trip: Trip! {
        didSet {
            self.updateUI()
            self.getRef()
        }
    }
    var ref: String?
    let user = Auth.auth().currentUser?.email!
    
    // if i use the else no need to initialize anything?
    func updateUI() {
        if let trip = trip {
            bgImageView.image = trip.bgImage
            titleLabel.text = trip.title
            colorView.backgroundColor = trip.color
            statsLabel.text = trip.status
            if trip.id == "N/A" {
                editBtn.isHidden = true
            } else {
                editBtn.isHidden = false 
            }
        } else {
            bgImageView.image = UIImage(named: "bg1")
            titleLabel.text = "Upcoming trip"
            colorView.backgroundColor = .black
            statsLabel.text = "Brainstorming open"
        }
        
        bgImageView.layer.cornerRadius = 15.0
        colorView.layer.cornerRadius = 15.0
        bgImageView.layer.masksToBounds = true
        colorView.layer.masksToBounds = true
        
    }
    
    func getRef() {
        ref = trip.id
    }
    @IBAction func editBtnTappedCol(_ sender: UIButton) {
        
        
        let docRef = db.collection("trips").document(ref!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()!
                
                // the user is the leader of the trip - use alert to let them know they will be deleting for everyone
                if let leader = data["leader"] as? String  {
                    
                    if leader == self.user! {
                        
                        let alert = UIAlertController(title: "Delete?", message: "This operation cannot be undone.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Delete for all", style: .destructive, handler: { (action) in
                            
                            self.db.collection("trips").document(self.ref!).delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("trip leader successfully removed!")
                                }
                            }
                            
                            self.db.collection("userTrips")
                                .whereField("tripID", isEqualTo: self.ref!)
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        let docs = querySnapshot!.documents
                                        for doc in docs {
                                            let refToDelete = doc.documentID
                                            
                                            // deletes from userTrips
                                            self.db.collection("userTrips")
                                                .document(refToDelete).delete() { err in
                                                    if let err = err {
                                                        print("Error removing document: \(err)")
                                                    } else {
                                                        print("user trip leader  successfully removed!")
                                                    }
                                                }//delete
                                        }//for
                                    } //else
                                }//get docs
                        }))
                        alert.addAction(UIAlertAction(title: "Delete for me", style: .destructive, handler: { (action) in
                            self.db.collection("userTrips")
                                .whereField("tripID", isEqualTo: self.ref!)
                                .whereField("user", isEqualTo: self.user!)
                                //                        .limit(to: 1)
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        let docs = querySnapshot!.documents
                                        if let refToDelete = docs.first?.documentID {
                                            
                                            // deletes from userTrips
                                            self.db.collection("userTrips")
                                                .document(refToDelete).delete() { err in
                                                    if let err = err {
                                                        print("Error removing document: \(err)")
                                                    } else {
                                                        print("user trip non leader successfully removed!")
                                                    }
                                                }
                                        }
                                    }
                                }
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                        self.parentContainerViewController()!.present(alert, animated: true)
                        
                    }  else if leader == "N/A" {
                        //single trip
                        let alert = UIAlertController(title: "Delete?", message: "This operation cannot be undone.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                            
                            self.db.collection("trips").document(self.ref!).delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("trip leader successfully removed!")
                                }
                            }
                            
                            self.db.collection("userTrips")
                                .whereField("tripID", isEqualTo: self.ref!)
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        let docs = querySnapshot!.documents
                                        for doc in docs {
                                            let refToDelete = doc.documentID
                                            
                                            // deletes from userTrips
                                            self.db.collection("userTrips")
                                                .document(refToDelete).delete() { err in
                                                    if let err = err {
                                                        print("Error removing document: \(err)")
                                                    } else {
                                                        print("user trip leader  successfully removed!")
                                                    }
                                                }//delete
                                        }//for
                                    } //else
                                }//get docs
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                        self.parentContainerViewController()!.present(alert, animated: true)
                        
                    }else  {
                        // not leader, not single trip
                        let alert = UIAlertController(title: "Delete?", message: "This operation cannot be undone.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                            self.db.collection("userTrips")
                                .whereField("tripID", isEqualTo: self.ref!)
                                .whereField("user", isEqualTo: self.user!)
                                //                        .limit(to: 1)
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        let docs = querySnapshot!.documents
                                        if let refToDelete = docs.first?.documentID {
                                            
                                            // deletes from userTrips
                                            self.db.collection("userTrips")
                                                .document(refToDelete).delete() { err in
                                                    if let err = err {
                                                        print("Error removing document: \(err)")
                                                    } else {
                                                        print("user trip non leader successfully removed!")
                                                    }
                                                }
                                        }
                                    }
                                }
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                        self.parentContainerViewController()!.present(alert, animated: true)
                        
                    } // else end (not leader)
                    
                }
            } else {
                print("Document does not exist")
            }
        }// get doc end
        
        
        
        // delete Alerts
        self.db.collection("alerts")
            .whereField("tripID", isEqualTo: self.ref!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let docs = querySnapshot!.documents
                    for doc in docs {
                        let ref = doc.documentID
                        
                        self.db.collection("alerts")
                            .document(ref).delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Alert successfully removed!")
                                    
                                }
                            }
                        
                        
                    }
                    
                }
            }
        
        
        
        
        //        if let colView = sender.superview?.superview?.superview?.superview as? UICollectionView {
        //        }
    }
    
}



