//
//  FirstViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 21/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class TripsViewController: UIViewController {
    
    @IBOutlet weak var tripsCollectionView: UICollectionView!
    
    @IBOutlet weak var newTripButton: UIButton!
    @IBOutlet weak var joinTripButton: UIButton!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var optionsView: UIView!
    
    
    let db = Firestore.firestore()
    var trips: [Trip] = []
    var newTrip: String? = nil
    
    //    @IBOutlet weak var addItem: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        
        tripsCollectionView.dataSource = self
        //        addItem.accessibilityFrame.size = CGSize(width: 100, height: 100)
        tripsCollectionView.delegate = self
        optionsView.isHidden = true

        optionsView.clipsToBounds = true
        optionsView.layer.cornerRadius = 20
        optionsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        newTripButton.layer.cornerRadius = 15.0
        newTripButton.frame.size.height = 75.0
        newTripButton.frame.size.width = 230.0
        joinTripButton.layer.cornerRadius = 15.0
        joinTripButton.frame.size.height = 75.0
        joinTripButton.frame.size.width = 230.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
       
        load()
    }
    
    @IBAction func newTripTapped(_ sender: UIButton) {
        
        optionsView.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func newTripOptionTapped(_ sender: UIButton) {
        optionsView.isHidden = true
        tabBarController?.tabBar.isHidden = false
        performSegue(withIdentifier: K.startToNewTrip, sender: self)
    }
    
    
    
    /// must use arrange by date
    func load() {
        
        if let user = Auth.auth().currentUser?.email {
            print (user)
            db.collection("trips")
                .whereField("participantsEmailsArray", arrayContains: user)
                .order(by: "dateAdded", descending: true)
                .addSnapshotListener { (querySnapshot, error) in
                   
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    self.trips = []
                    
                    for document in documents {
                        //                        print("i am inside document")
                        //                        print(querySnapshot!.documents.count)
                        let data = document.data()
                        let ref = document.documentID
                        //                        print(ref)
                        //                        print(data)
                        
                        
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
                                //                                print(" i am about to form the trip")
                                if let finalImage = UIImage(named: bgImage), let finalColor = UIColor(named: color) {
                                    let trip = Trip(id: ref, title: title, bgImage: finalImage, color: finalColor)
                                    print(trip)
                                    self.trips.append(trip)
                                    
                                    DispatchQueue.main.async {
                                        self.tripsCollectionView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    
                }
            
        }
    }
    // How about user profile? Must storre locally? and then when changed in settings update the local vars.
    //    @IBAction func newTripButtonTapped(_ sender: Any) {
    //
    //          // use the auth data stored loclly for no of trips and setting the bg and side color
    //
    //          if let user = Auth.auth().currentUser?.email {
    //        let newTripRef = db.collection("trips").document()
    ////            print(newTripRef.documentID)
    //        newTripRef.setData([
    //            "bgImage": "bg2",
    //            "calculated": false,
    //            "color": "BrandOrange",
    //            "dateAdded": FieldValue.serverTimestamp(),
    //            "endDate": [
    //            ],
    //             "events" : "reference here",
    //             "leader": user,
    //             "locations": [
    //
    //             ],
    //            "name": [
    //
    //                ],
    //
    //            "noParticipants": 1,
    //            "participants": [
    //                [
    //                    "name" : "New User",
    //                    "email": user
    //                ]
    //            ],
    //            "participantsEmailsArray": [
    //                user
    //            ],
    //            "participantsNamesArray": [
    //                "New User"
    //            ],
    //            "startDate": [
    //
    //            ],
    //            "tune": [
    //
    //
    //            ]
    //        ]) { (error) in
    //            if let e = error {
    //                print(e.localizedDescription)
    //            } else {
    //                self.newTrip = newTripRef.documentID
    //                print("new trip reference -----")
    //                print(self.newTrip)
    //
    //                self.performSegue(withIdentifier: K.tripsToTripContent, sender: self)
    //            }
    //        }
    //    }
    //    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TripContentViewController {
            if let nt = newTrip  {
                destinationVC.selectedTrip = nt
                TripContentAddNameCell.selectedTrip = nt
                //                TripContentAddParticipantsCell.selectedTrip = nt
                TripContentAddLocationCell.selectedTrip = nt
                TripContentAddTuneCell.selectedTrip = nt
                TripContentAddStartDateCell.selectedTrip = nt
                TripContentAddEndDateCell.selectedTrip = nt
                TripContentAddCell.selectedTrip = nt
                TripContentShowCell.selectedTrip = nt
                print("I am being called before segue")
                
                
            } else {
                if let selectedIndex = tripsCollectionView.indexPathsForSelectedItems?[0] {
                    destinationVC.selectedTrip = trips[selectedIndex.row].id
                    TripContentAddNameCell.selectedTrip = trips[selectedIndex.row].id
                    //                    TripContentAddParticipantsCell.selectedTrip = trips[selectedIndex.row].id
                    TripContentAddLocationCell.selectedTrip = trips[selectedIndex.row].id
                    TripContentAddTuneCell.selectedTrip = trips[selectedIndex.row].id
                    TripContentAddStartDateCell.selectedTrip = trips[selectedIndex.row].id
                    TripContentAddEndDateCell.selectedTrip = trips[selectedIndex.row].id
                    TripContentAddCell.selectedTrip = trips[selectedIndex.row].id
                    TripContentShowCell.selectedTrip = trips[selectedIndex.row].id
                }
            }
        }
    }
    
}

//MARK: - Data source
extension TripsViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCollectionViewCell", for: indexPath) as! TripCollectionViewCell
        let trip = trips[indexPath.item]
        cell.trip = trip
        
        return cell
    }
    
    
    
}

//MARK: - Collection View Delegate

extension TripsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.tripsToTripContent, sender: self)
    }
}

