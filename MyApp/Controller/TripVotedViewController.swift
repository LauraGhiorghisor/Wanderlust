//
//  TripVotedViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 12/11/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class TripVotedViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tuneLabel: UILabel!
    //    Map
    @IBOutlet weak var mapView: MKMapView!
    var spanValue: CLLocationDegrees = 0.5
    
    let df = DateFormatter()
    let db = Firestore.firestore()
    var selectedTrip: String? {
        didSet {
            load()
        }
    }
    var selectedRegion: MKCoordinateRegion?
    
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TripEventsListViewController {
            destinationVC.selectedTrip = selectedTrip!
            destinationVC.selectedRegion = selectedRegion
        }
        if let destinationVC = segue.destination as? NotesViewController {
            destinationVC.selectedTrip = selectedTrip!
        }
        
        if let destinationVC = segue.destination as? AddParticipantsModalViewController {
            destinationVC.selectedTrip = selectedTrip!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        load()
        
        print(view.frame.size.height)
        if view.frame.size.height > 840 {
            print("it is more than 840 ")
            mapHeight.constant = 350.0
            mapView.layoutIfNeeded()
            mapHeight.isActive = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        let newBackButton = UIButton()
        newBackButton.setTitle("Trips", for: .normal)
        newBackButton.setImage(UIImage(systemName: "chevron.left",
                                       withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)), for: .normal)
        
        newBackButton.addTarget(self, action: #selector(TripVotedViewController.back(sender:)), for: .touchUpInside)
        newBackButton.tintColor = UIColor(named: "BrandTeal")
        newBackButton.setTitleColor(UIColor(named: "BrandTeal"), for: .normal)
        newBackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -17.0, bottom: 0, right: 0.0)
        newBackButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
        let b = UIBarButtonItem(customView: newBackButton)
        self.navigationItem.setLeftBarButton(b, animated: false)
        
        
    }
 
    @IBAction func addParticipantTapped(_ sender: UIBarButtonItem) {
        let purchaseID = "com.lauraghiorghisor.wanderlust.premium"
        if UserDefaults.standard.bool(forKey: purchaseID) {
        performSegue(withIdentifier: K.votedToAddPeopleModal, sender: self)
        } else {
            performSegue(withIdentifier: K.votedToUpgradeModal, sender: self)
         
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewController(animated: true)
        
        //        performSegue(withIdentifier: "VotedToTrips", sender: self)
    }
    
    func load() {
        print("IN THE LOAD METHOD")
        let docRef = db.collection("trips").document(selectedTrip!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self.df.dateFormat = "dd MMM yyyy"
                var temp = ""
                if let location = data["votedLocation"] as? String {
                    if location == "" {
                        DispatchQueue.main.async {
                            self.locationLabel.text = "No vote was taken for location."
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.locationLabel.text = location
                            self.setUpMap(location: location)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.locationLabel.text = "No vote was taken for location."
                    }
                }
                
                if let tune = data["votedTune"] as? String {
                    if tune == "" {
                        DispatchQueue.main.async {
                            self.tuneLabel.text = "No vote was taken for tune."
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.tuneLabel.text = tune
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.tuneLabel.text = "No vote was taken on tune."}
                    
                }
                if let start = data["votedStartDate"] as? Timestamp {
                    DispatchQueue.main.async {
                        self.dateLabel.text = self.df.string(from: (start.dateValue()))
                    }
                    
                } else {
                    temp = "Undetermined"
                    
                }
                
                if let end = data["votedEndDate"] as? Timestamp {
                    
                    if temp == "Undetermined" {
                        DispatchQueue.main.async {
                            self.dateLabel.text = "Undetermined - \(self.df.string(from: (end.dateValue())))"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.dateLabel.text?.append(" - \(self.df.string(from: (end.dateValue())))")
                        }
                    }
                } else {
                // null
                    
                    if temp == "Undetermined" {
                        DispatchQueue.main.async {
                            self.dateLabel.text = "No vote was taken for dates."
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.dateLabel.text?.append(" - undetermined")
                        }
                    }
                
            }
            
        } else {
            print("Document does not exist")
        }
    }
}


func setUpMap(location: String) {
    
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = location
    request.region = mapView!.region
    let search = MKLocalSearch(request: request)
    search.start { response, _ in
        guard let response = response else {
            return
        }
        
        if response.mapItems.count > 0 {
            let item = response.mapItems[0]
            
            let location = CLLocationCoordinate2D(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: self.spanValue, longitudeDelta: self.spanValue)
            let region = MKCoordinateRegion(center: location, span: span)
            self.selectedRegion = region
            self.mapView!.setRegion(region, animated: true)
            
        } else {
            print("No results to show")
        }
        
        
    }
}
}
