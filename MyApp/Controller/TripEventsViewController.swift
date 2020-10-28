//
//  TripEventsViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import MapKit
import Firebase

// define our own protocol
protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, zoom: Bool)
}


// Before releasing an MKMapView object for which you have set a delegate, remember to set that object’s delegate property to nil. MapKit calls all of your delegate methods on the app's main thread.

class TripEventsViewController: UIViewController {
    
    
    // use a did set on location, coming from completed trip.
    var selectedRegion: MKCoordinateRegion? {
        // set to nil for new trip?
        didSet {
            zoomInOnSelectedRegion()
        }
    }
    
    var selectedTrip: String? {
        // set to nil for new trip?
        
        didSet {
            print("trip set in events VC")
        }
    }
    
    
    // use for adding pin to map
    var pinImage: String?
    var customSearchOn = false
    
    
    
    //<a href="https://www.vecteezy.com/free-vector/car">Car Vectors by Vecteezy</a>
    //<a href="https://www.vecteezy.com/free-vector/heart-shape">Heart Shape Vectors by Vecteezy</a>
    
    var resultSearchController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    var matchingItems: [MKMapItem] = []
    
    var selectedPin: MKPlacemark? = nil
    var spanValue: CLLocationDegrees = 0.05
    let db = Firestore.firestore()
    
    
    // buttons
    
    @IBOutlet weak var optionsView: UIView!
    
    @IBOutlet weak var pinNameOptionsView: UIView!
    
    @IBOutlet weak var openInMapsButton: UIButton!
    
    @IBOutlet weak var addToTripButton: UIButton!
    
    
    @IBOutlet weak var pinNameTF: UITextField!
    
    @IBOutlet weak var addToMapButton: UIButton!
    
    var pinNameOptionsViewShowing = false
    var optionsViewShowing = false
    
    
    // all annotations will be centralized, per session, in this array, with the purpose of triggering the next one when clicking.
    var currentAnnotations: [MKPointAnnotation] = []
    var placemarkForUserDeclaredPin: MKPlacemark?
        
    //MARK: - View did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // must initialize currentANnotations, or pass them from previous controller
        mapView.addAnnotations(currentAnnotations)
        
        //setting nav
        navigationController!.navigationBar.topItem?.title = "Events"
        navigationController!.navigationBar.tintColor = UIColor(named: "BrandTeal")
        
        // buttons
        optionsView.clipsToBounds = true
        optionsView.layer.cornerRadius = 20
        optionsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        openInMapsButton.layer.cornerRadius = 15.0
        addToTripButton.layer.cornerRadius = 15.0
        pinNameOptionsView.clipsToBounds = true
        pinNameOptionsView.layer.cornerRadius = 20
        pinNameOptionsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        addToMapButton.layer.cornerRadius = 15.0
        
        pinNameTF.layer.cornerRadius = 15.0
        pinNameTF.layer.masksToBounds = true
        pinNameTF.layer.borderColor = UIColor(named: "BrandTeal")?.cgColor
        pinNameTF.layer.borderWidth = 1.0
        pinNameTF.addPadding(.left(10))
        
        //tf delegate
        pinNameTF.delegate = self
        
        //delegates
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        let location = CLLocationCoordinate2D(latitude: 51.50, longitude: 0.12)
        let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)
        selectedRegion = MKCoordinateRegion(center: location, span: span)
        //            mapView.setRegion(selectedRegion!, animated: true)
        
        
        // Creates the view controller with the specified identifier and initializes it with the data from the storyboard.
        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        //        resultSearchController?.automaticallyShowsCancelButton = false
        resultSearchController?.showsSearchResultsController = true
        //        resultSearchController?.automaticallyShowsScopeBar = true
        navigationItem.titleView = resultSearchController?.searchBar
        //        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        
        //delegate for annotations
        locationSearchTable.handleMapSearchDelegate = self
        
        mapView.delegate = self
    }
    
    
    // options buttons
    // did tap??????????
    @IBAction func openInMapsTapped(_ sender: UIButton) {
        getDirections()
        optionsView.isHidden = true
    }
    
    @IBAction func addToTripTapped(_ sender: UIButton) {
        addToFavourites()
        optionsView.isHidden = true
    }
    
    @IBAction func addToMapTapped(_ sender: UIButton) {
        
       
        if let safeText = pinNameTF.text, let placemarkPin = placemarkForUserDeclaredPin {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemarkPin.coordinate
            annotation.title = safeText
            if let city = placemarkPin.locality, let state = placemarkPin.administrativeArea {
                annotation.subtitle = "\(city), \(state)"
            }
            mapView.addAnnotation(annotation)
            currentAnnotations.append(annotation)
        }
      
        addToMapButton.resignFirstResponder()
        pinNameOptionsView.isHidden = true
    }
    
    
    // https://stackoverflow.com/questions/34431459/ios-swift-how-to-add-pinpoint-to-map-on-touch-and-get-detailed-address-of-th
    
    
    @IBAction func mapDidTap(_ sender: UITapGestureRecognizer) {
        
        if optionsView.isHidden == false {
        optionsView.isHidden = true
            return
        }
        if pinNameOptionsView.isHidden == false {
        pinNameOptionsView.isHidden = true
            return
        }
        
        optionsView.isHidden = true
        pinNameOptionsView.isHidden = true
        //        let location = sender.location(in: mapView)
        //        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        //
        //
        //        let geoLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        //        let geocoder = CLGeocoder()
        //        geocoder.reverseGeocodeLocation(geoLoc) { placemarks, error in
        //
        //            guard error == nil else {
        //                print("*** Error in \(#function): \(error!.localizedDescription)")
        //                return
        //            }
        //
        //            guard let placemark = placemarks?[0] else {
        //                print("*** Error in \(#function): placemark is nil")
        //                return
        //            }
        //
        //
        //            print("do we have a name")
        //            print(placemark.name )
        //            print(placemark.areasOfInterest)
        //            print(placemark.locality)
        //
        //            var p = MKPlacemark(placemark: placemark)
        //            print("trying mkpl")
        //            print(p.name)
        //
        
        //        }
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        for ann in currentAnnotations {
            print("going here")
            if ann.coordinate.longitude <= coordinate.longitude + 0.001 && ann.coordinate.longitude >= coordinate.longitude - 0.001 && ann.coordinate.latitude <= coordinate.latitude + 0.001 && ann.coordinate.latitude >= coordinate.latitude - 0.001 {
                print("CLICKING ON ANNOTATIOOOOON")
                return
            }
        }
        
        
        customSearchOn = true
        pinImage = "mappin.circle"
        
        let geoLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(geoLoc) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                return
            }
            
            let request = MKLocalSearch.Request()
            //                    request.naturalLanguageQuery = "\(coordinate.latitude)\u{00B0}N \(coordinate.longitude) \u{00B0}E"
            request.naturalLanguageQuery = placemark.name!
            print("the query is")
            print(request.naturalLanguageQuery!)
            request.region = self.mapView!.region
            request.pointOfInterestFilter = .includingAll
            // could add courts
            
//                        let poiCustom1 = MKPointOfInterestCategory(rawValue: "Coffee shop")
//            request.pointOfInterestFilter = .init(including: [poiCustom1, .airport,.amusementPark, .aquarium, .atm, .bakery, .bank, .beach, .brewery,   .restroom, .restaurant])
            request.resultTypes = .pointOfInterest
            
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    
                    
                        print("make new option to add text here ")
                        self.pinNameOptionsView.isHidden = false
                    self.placemarkForUserDeclaredPin = MKPlacemark(placemark: placemark)
                    return
                    
                }
                
                                print("the items", response.mapItems)
                if response.mapItems.count > 0 {
                    print("thre are items")
                    let item = response.mapItems[0]
                    print(item)
                    //                    if item.pointOfInterestCategory != .none {
                    self.dropPinZoomIn(placemark: item.placemark, zoom: false)
                    //                    }
                    //
                }

                
                
//                                for item in response.mapItems {
//                                    print(item)
//                                    var found = false
//                                    for annotation in self.currentAnnotations {
//                                        if item == annotation {
//                                            found = true
//                                        }
//                                    }
//                                    if found == true {
//                                        continue
//                                    } else {
//                                        self.dropPinZoomIn(placemark: item.placemark, zoom: false)
//                                        break
//                                    }
//
//                                }
                
                
                
                //                    if let name = item.name, let location = item.placemark.location {
                //                        print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
                //                        self.dropPinZoomIn(placemark: item.placemark, zoom: false)
                //                    }
                
            }
        }
        customSearchOn = false
    }
    
    @IBAction func mapDidPressLong(_ sender: UILongPressGestureRecognizer) {
//        let location = sender.location(in: mapView)
//        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
//
//        customSearchOn = true
//        pinImage = "mappin.circle"
//
//        let geoLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(geoLoc) { placemarks, error in
//
//            guard error == nil else {
//                print("*** Error in \(#function): \(error!.localizedDescription)")
//                return
//            }
//
//            guard let placemark = placemarks?[0] else {
//                print("*** Error in \(#function): placemark is nil")
//                return
//            }
//
//            let request = MKLocalSearch.Request()
//            //                    request.naturalLanguageQuery = "\(coordinate.latitude)\u{00B0}N \(coordinate.longitude) \u{00B0}E"
//            request.naturalLanguageQuery = placemark.name!
//            print("the query is")
//            print(request.naturalLanguageQuery!)
//            request.region = self.mapView!.region
//            request.pointOfInterestFilter = .includingAll
//            //            let poiCustom1 = MKPointOfInterestCategory(rawValue: "Coffee shop")
//            //            request.pointOfInterestFilter = .init(including: [poiCustom1, .airport,.amusementPark, .aquarium, .atm, .bakery, .bank, .beach, .brewery, .  .restroom, .restaurant])
//            request.resultTypes = .pointOfInterest
//
//            let search = MKLocalSearch(request: request)
//            search.start { response, _ in
//                guard let response = response else {
//                    return
//                }
//
//                //                print("the items", response.mapItems)
//                if response.mapItems.count > 0 {
//                    print("thre are items")
//                    let item = response.mapItems[0]
//                    print(item)
//                    //                    if item.pointOfInterestCategory != .none {
//                    self.dropPinZoomIn(placemark: item.placemark, zoom: false)
//                    //                    }
//                    //
//                }
//                else {
//                    print("make new option to add text here ")
//                    self.pinNameOptionsView.isHidden = false
//                }
//                //
//                //                for item in response.mapItems {
//                //                    print(item)
//                //
//                //                }
//
//
//
//                //                    if let name = item.name, let location = item.placemark.location {
//                //                        print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
//                //                        self.dropPinZoomIn(placemark: item.placemark, zoom: false)
//                //                    }
//
//            }
//        }
//        customSearchOn = false
    }
    
    
    
    
    func zoomInOnSelectedRegion() {
        print("calling the zoommethod because region has been set ---------")
        if let safeRegion = selectedRegion {
            mapView.setRegion(safeRegion, animated: true)
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            
            if let safeLocation = locationManager.location {
                let currentLocation = CLLocationCoordinate2D(latitude: safeLocation.coordinate.latitude, longitude: safeLocation.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
                let currentRegion = MKCoordinateRegion(center: currentLocation, span: span)
                mapView.setRegion(currentRegion, animated: true)
            }
            
        }
        
    }
    
    @IBAction func restaurantsSearch(_ sender: UIButton) {
        customSearch(pinImage: "gift", searFor: "Restaurants")
    }
    
    
    @IBAction func cafesSearch(_ sender: UIButton) {
        
        customSearch(pinImage: "bed.double", searFor: "Coffee & Tea")
    }
    
    
    @IBAction func lodgingSearch(_ sender: UIButton) {
        
        customSearch(pinImage: "bed.double.fill", searFor: "Hotels & Events")
        customSearch(pinImage: "bed.double.fill", searFor: "Lodging")
        customSearch(pinImage: "bed.double.fill", searFor: "Rent")
        customSearch(pinImage: "bed.double.fill", searFor: "Hotel")
        
    }
    
    @IBAction func touristSearch(_ sender: UIButton) {
        customSearch(pinImage: "camera.fill", searFor: "Touristic attractions")
    }
    
    
    @IBAction func museumSearch(_ sender: UIButton) {
        customSearch(pinImage: "house.fill", searFor: "Museums")
    }
    
    
    
    func customSearch(pinImage image: String, searFor keyWord: String) {
        customSearchOn = true
        pinImage = image
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyWord
        request.region = mapView!.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            
            for place in response.mapItems {
                self.dropPinZoomIn(placemark: place.placemark, zoom: false)
            }
            
            
        }
        //            customSearchOn = false
        //    pinImage = "mappin.circle.fill"
    }
    
    
}
extension TripEventsViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let safeLocation = locations.first {
            //            // why is it first?????????
            let location = CLLocationCoordinate2D(latitude: safeLocation.coordinate.latitude, longitude: safeLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}



//MARK: - Handle map search

extension TripEventsViewController: HandleMapSearch {
    
    
    func dropPinZoomIn(placemark: MKPlacemark, zoom: Bool) {
        
        /// MUST ALSO MAKE THE NEW PIN FOCUS !!!!!!!
        selectedPin = placemark
        // clear existing pins
        //         mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        currentAnnotations.append(annotation)
        if zoom {
            let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
}

//MARK: - Map View Delegate - handles clicking on annotations
extension TripEventsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        print(" i am in didadd views")
        //            for view in views {
        //                view.
        //            }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        optionsView.isHidden = false
        
    }
    
    
    //        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //
    //            if annotation is MKUserLocation {
    //                //return nil so map view draws "blue dot" for standard user location
    //                return nil
    //            }
    //
    
    
    //            let reuseId = "pin"
    //            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    //            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    //            guard let pw = pinView else {
    //                print("Pin view was null")
    //                return nil
    //            }
    //
    //
    //            if #available(iOS 11.0, *) {
    //                pw.clusteringIdentifier = "PinCluster"
    //            } else {
    //               // Fallback on earlier versions
    //            }
    //
    //            // should probs be set before adding it?
    //            //            pw.image = UIImage(systemName: pinImage!)
    //
    ////            if customSearchOn {
    ////                print("IS THI SCUSTOM SEARCH ONNVBKDHFBRKBF")
    ////                pw.image = UIImage(systemName: "car")
    ////
    ////            } else {
    ////                pw.image = UIImage(systemName: "mappin")
    ////            }
    //            pw.image = UIImage(systemName: "flag")
    //            pw.animatesDrop = true
    //            pw.pinTintColor = .systemOrange
    //            pw.canShowCallout = true
    //            let smallSquare = CGSize(width: 35  , height: 27)
    //
    //            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
    //            button.setBackgroundImage(UIImage(systemName: "car"), for: .normal)
    //            button.tintColor = UIColor(named: "BrandTeal")
    //            button.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)
    //            pinView?.leftCalloutAccessoryView = button
    //
    //            let addButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
    //            addButton.setBackgroundImage(UIImage(systemName: "text.badge.plus"), for: .normal)
    //            addButton.tintColor = UIColor(named: "BrandTeal")
    //            addButton.addTarget(self, action: #selector(self.addToFavourites), for: .touchUpInside)
    //            addButton.setTitleColor(UIColor.systemOrange, for: .normal)
    //            pinView?.rightCalloutAccessoryView = addButton
    //            return pw
    //        }
    
    
    
    //MARK: - Rewrite to do other stuff such as add to ur list of objecties etc.
    @objc func getDirections () {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            //                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            
            // https://stackoverflow.com/questions/28604429/how-to-open-maps-app-programmatically-with-coordinates-in-swift
            let latitude:CLLocationDegrees =  selectedPin.coordinate.latitude
            let longitude:CLLocationDegrees =  selectedPin.coordinate.longitude
            
            let regionDistance:CLLocationDistance = 100
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            
            //                let dirRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selectedPin.coordinate.latitude, longitude: selectedPin.coordinate.longitude), span:)
            
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let launchOpt2 = [MKLaunchOptionsMapCenterKey : MKLaunchOptionsMapCenterKey]
            mapItem.name = mapItem.placemark.name
            print("printing the name-----------")
            mapItem.openInMaps(launchOptions: nil)
            //                mapItem.openInMaps(launchOptions: <#T##[String : Any]?#>, from: <#T##UIScene?#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
            
            //                if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
            //                    UIApplication.shared.openURL(NSURL(string:
            //                                                                "http://maps.apple.com/?daddr=San+Francisco,+CA&saddr=cupertino")! as URL)
            //                } else {
            //                  NSLog("Can't use Apple Maps");
            //                }
        }
    }
    //MARK: - Add to favourites implementation
    @objc func addToFavourites() {
        if let safePin = selectedPin {
            print("added to favourites")
            
            
            // must use geocoder to reverse from coord to address
            let location = CLLocation(latitude: safePin.coordinate.latitude, longitude: safePin.coordinate.longitude)
            print(location)
            
            let gp = GeoPoint(latitude: safePin.coordinate.latitude, longitude: safePin.coordinate.longitude)
            
            //                selectedTrip = "7VuLZ4KgYxTMQWIa7dkX"
            db.collection("locations").whereField("tripID",  isEqualTo: selectedTrip!)
                .getDocuments { (querySnapshot, err) in
                    
                    if let docs = querySnapshot?.documents {
                        
                        if docs.count > 0 {
                            
                            print("there are docs ", docs.count)
                            
                            let ref = docs[0].reference
                            
                            
                            ref.updateData([
                                //                                "tripID": self.selectedTrip!,
                                "locations": FieldValue.arrayUnion([gp])
                                //                                "dateAdded": FieldValue.serverTimestamp()
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        } else {
                            let ref = self.db.collection("locations").document()
                            ref.setData ([
                                "tripID": self.selectedTrip!,
                                "locations": FieldValue.arrayUnion([gp])
                                //                                    "dateAdded": FieldValue.serverTimestamp()
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                            
                        }
                    }
                }
            
            
            
            
        }
    }
}

//MARK: - TF delegate
extension TripEventsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pinNameTF {
            print("pin tf OK")
            pinNameTF.resignFirstResponder()
            addToMapButton.becomeFirstResponder()
        }
        return true
    }
}
