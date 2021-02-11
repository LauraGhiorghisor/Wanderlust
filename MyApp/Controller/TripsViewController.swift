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
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    let db = Firestore.firestore()
    var trips: [Trip] = []
    let purchaseID = "com.lauraghiorghisor.wanderlust.premium"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        
        tripsCollectionView.dataSource = self
        tripsCollectionView.delegate = self
        optionsView.isHidden = true
        
        optionsView.clipsToBounds = true
        optionsView.layer.cornerRadius = 20
        optionsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        newTripButton.layer.cornerRadius = 15.0
        newTripButton.frame.size.height = 75.0
        newTripButton.frame.size.width = 230.0
        joinTripButton.layer.cornerRadius = 15.0
        joinTripButton.frame.size.height = 75.0
        joinTripButton.frame.size.width = 230.0

        tripsCollectionView.flashScrollIndicators()
        
        tapGesture.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        load()
    }
    
    
    @IBAction func newTripTapped(_ sender: UIButton) {
        
        tabBarController?.tabBar.isHidden = true
        optionsView.isHidden = false
        tapGesture.isEnabled = true
    }
    
    
    
    @IBAction func tapOnView(_ sender: UITapGestureRecognizer) {
        
        if optionsView.isHidden == false {
            optionsView.isHidden = true
            tabBarController?.tabBar.isHidden = false
            tapGesture.isEnabled = false
        }
    }
    
    
    @IBAction func newTripOptionTapped(_ sender: UIButton) {
        optionsView.isHidden = true
        tabBarController?.tabBar.isHidden = false
        tapGesture.isEnabled = false
    }
    
    @IBAction func groupTripTapped(_ sender: UIButton) {
      
        if isPurchased() == true {
            performSegue(withIdentifier: K.startToNewTrip, sender: self)
        } else {
            performSegue(withIdentifier: K.startToModalUpgrade, sender: self)
        }
    }
    
    func isPurchased () -> Bool {
        let purchaseStat = UserDefaults.standard.bool(forKey: purchaseID)
        if purchaseStat {
            return true
        } else {
            return false
        }
        
    }
    
    
    
    func load() {
        if let user = Auth.auth().currentUser?.email {
            print (user)
            db.collection("userTrips")
                .whereField("user", isEqualTo: user)
                .order(by: "dateAdded", descending: true)
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    self.trips = []
                    
                    for document in documents {
                        let data = document.data()
                        if let ref = data["tripID"] as? String,
                           let name = data["name"] as? String, let bgImage = data["bgImage"] as? String, let color = data["color"] as? String, let status = data["status"] as? String, let leader = data["leader"] as? String {
                            if let finalImage = UIImage(named: bgImage), let finalColor = UIColor(named: color) {
                                let trip = Trip(id: ref, title: name, bgImage: finalImage, color: finalColor, status: status, leader: leader)
                                print(trip)
                                self.trips.append(trip)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tripsCollectionView.reloadData()
                        self.tripsCollectionView.flashScrollIndicators()
                    }
                }
        }
    }
    
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TripContentViewController {
            if let selectedIndex = tripsCollectionView.indexPathsForSelectedItems?[0] {
                destinationVC.selectedTrip = trips[selectedIndex.row].id
                TripContentAddNameCell.selectedTrip = trips[selectedIndex.row].id
                TripContentAddLocationCell.selectedTrip = trips[selectedIndex.row].id
                TripContentAddTuneCell.selectedTrip = trips[selectedIndex.row].id
                TripContentAddStartDateCell.selectedTrip = trips[selectedIndex.row].id
                TripContentAddEndDateCell.selectedTrip = trips[selectedIndex.row].id
                TripContentAddCell.selectedTrip = trips[selectedIndex.row].id
                TripContentShowCell.selectedTrip = trips[selectedIndex.row].id
            }
        }
        
        if let destinationVC = segue.destination as? TripVotedViewController {
            if let selectedIndex = tripsCollectionView.indexPathsForSelectedItems?[0] {
                destinationVC.selectedTrip = trips[selectedIndex.row].id
            }
        }
    }
}

//MARK: - Data source
extension TripsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trips.count == 0 {
        return trips.count + 1
        } else {
            return trips.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCollectionViewCell", for: indexPath) as! TripCollectionViewCell
        if trips.count == 0 {
            cell.trip = Trip(id: "N/A", title: "Trips go here!", bgImage: UIImage(named: "bg1")!, color: UIColor(named: K.CorporateColours.teal)!, status: "Click the plus button to add your own trip...", leader: "N/A")
        } else {
            let trip = trips[indexPath.item]
            cell.trip = trip
        }
        self.tripsCollectionView.flashScrollIndicators()
        return cell
    }
}

//MARK: - Collection View Delegate
extension TripsViewController: UICollectionViewDelegate {
    // must also adds rules for tapping out for bottom btns and edit btn
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if indexPath.row == 0 && trips.count == 1 && trips[indexPath.row].id == "N/A" {
        if trips.count == 0 {
        return
        } else {
            let trip = trips[indexPath.item]
            if trip.status == K.status.brainstormingOpen || trip.status == K.status.votingOpen {
                performSegue(withIdentifier: K.tripsToTripContent, sender: self)
            }
            else if trip.status ==  K.status.votingClosed {
                performSegue(withIdentifier: K.tripsToVotingClosed, sender: self)
            }
        }
       
    }
    
    
    
}

//MARK: - some delegate
extension TripsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 40.0
        var height: CGFloat = 0.0
        print(view.frame.size.height)
        // 736 for 8 plus => 556
        // 896 for 11 pro max
        // 844 for 12
        // 926 - 12 pro max
        // 8 plus
        if view.frame.size.height <= 756 {
            height = view.frame.size.height - 180
        } else {
            height = view.frame.size.height - 288
        }
        return CGSize(width: width, height: height)
    }
}
