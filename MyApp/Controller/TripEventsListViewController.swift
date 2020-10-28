//
//  TripEventsListViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 26/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class TripEventsListViewController: UIViewController {

    @IBOutlet weak var eventsTableView: UITableView!
    var events: [String] = []
    let db = Firestore.firestore()
    
    var selectedTrip: String? {
        didSet {
            load()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        self.navigationItem.title = "Events"
        
        eventsTableView.dataSource = self
        eventsTableView.register(UINib(nibName: K.tripEventNibName, bundle: nil), forCellReuseIdentifier: K.tripEventCellIdentifier)
        eventsTableView.delegate = self
//        load()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TripEventsViewController {
            // set selectedRegion based on ?????
            destinationVC.selectedTrip = selectedTrip!
        }
    }

    
    func load() {
        db.collection("locations")
            .whereField("tripID", isEqualTo: selectedTrip!)
//            .order(by: "dateAdded")
            .addSnapshotListener() { (querySnapshot, err) in
                self.events = []
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let queryDocs = querySnapshot?.documents {
                        
                        for doc in queryDocs {
                            let data = doc.data()
                            
                            
                            if let locations = data["locations"] as? Array<GeoPoint> {
                             
                                for location in locations {
                                  
                                    let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                                
                                    let geocoder = CLGeocoder()
                                    geocoder.reverseGeocodeLocation(clLocation) { (places, error) in

                                        if let e = error {
                                            print("there was an error reversing", e)
                                        } else {
                                        if let place = places?.first {
                                            print("here should be the name =-----------")
                                            print(place.name)
                                            print(place.areasOfInterest)
                                            self.events.append(place.name!)
                                            DispatchQueue.main.async {
                                                self.eventsTableView.reloadData()
                                            }

                                        }
                                        }

                                    }
                                    
                                   
                                }
                                print("These should be the events -------s")
                                print(self.events)
                            }
                        
                        }
                    }
                }
                
            }
    }
}

//MARK: - Data source

extension TripEventsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: K.tripEventCellIdentifier, for: indexPath) as! TripEventCell
        
        cell.titleLabel.text = event
        return cell
    }
    
    
    // read from db.
}

//MARK: - Table view delegate
extension TripEventsListViewController: UITableViewDelegate {
    
    
}
