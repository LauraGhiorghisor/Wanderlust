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
    @IBOutlet weak var emptyView: UIView!
    var events: [Location] = []
    let db = Firestore.firestore()
    let df = DateFormatter()
    
    var selectedTrip: String? {
        didSet {
            print("DID SET ")
            load()
        }
    }
    var selectedRegion: MKCoordinateRegion?
    var selectedLocation: Location?
    
    @IBOutlet weak var viewAllBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        df.dateFormat = "dd MMM YYYY"
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        navigationItem.backButtonTitle = ""
//        self.navigationItem.title = "Events"

        
        eventsTableView.dataSource = self
        eventsTableView.register(UINib(nibName: K.tripEventNibName, bundle: nil), forCellReuseIdentifier: K.tripEventCellIdentifier)
        eventsTableView.delegate = self
        
        if events.count == 0 {
        viewAllBtn.isHidden = true
        } else {
            viewAllBtn.isHidden = false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TripEventsViewController {
         
          
            destinationVC.selectedTrip = selectedTrip
            if segue.identifier == K.eventsToNewEvent {
          
            destinationVC.selectedRegion = selectedRegion
            }
            if segue.identifier == K.eventCellToMap {
                
                destinationVC.selectedLocation = selectedLocation
            }
        
            if segue.identifier == K.viewAllToEvents {
            destinationVC.allLocations = events
        }
        }
    }

    // muts order by date 
    func load() {
 print("I AM LOADING")
        db.collection("locations")
            .whereField("tripID", isEqualTo: selectedTrip!)
            .order(by: "dateAdded")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                           print("Error fetching documents: \(error!)")
                           return
                       }
                if documents.count == 0 {
                    DispatchQueue.main.async {
                        self.view.bringSubviewToFront(self.emptyView)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.bringSubviewToFront(self.eventsTableView)
                    }
                    self.events = []
                    for document in documents {
                        let data = document.data()
                        if let gp = data["gp"] as? GeoPoint, let title = data["title"] as? String, let subtitle = data["subtitle"] as? String, let id = data["tripID"] as? String, let city = data["city"] as? String, let state = data["state"] as? String {
                            print("PASSED THE CHECKS ")
                            let loc = CLLocation(latitude: gp.latitude, longitude: gp.longitude)
                            self.events.append(Location(gp: loc, title: title, subtitle: subtitle, id: id, city: city, state: state))
                        } else {
                            print("DIDNT PASS")
                        }
                        DispatchQueue.main.async {
                            self.eventsTableView.reloadData()
                            if self.events.count == 0 {
                                self.viewAllBtn.isHidden = true
                            } else {
                                self.viewAllBtn.isHidden = false
                            }
                        }
                    } // end for
                } // end else count > 0
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
        cell.titleLabel.text = event.title
        cell.line1Label.text = event.subtitle
        return cell
    }
    
    
    // read from db.
}

//MARK: - Table view delegate
extension TripEventsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
       
        // set up the selected region
        let location = events[indexPath.row].coordinate
        let currentLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
         selectedRegion = MKCoordinateRegion(center: currentLocation, span: span)
        selectedLocation = events[indexPath.row]
      
        performSegue(withIdentifier: K.eventCellToMap, sender: self)
        
    }
    
}
