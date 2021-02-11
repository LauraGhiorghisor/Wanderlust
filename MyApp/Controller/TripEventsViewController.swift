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
import CoreLocation

// MUST ADD ALL ITEMS TO MAP WHEN LOADING
protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, zoom: Bool)
    func dropPinZoomIn(ann: MKAnnotation, zoom: Bool)
}


class TripEventsViewController: UIViewController {
    
    var selectedRegion: MKCoordinateRegion?
    
    var selectedTrip: String? {
        didSet {
            print("trip set in events VC")
        }
    }
    var selectedLocation: Location?
    var allLocations: [Location]?
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var pinNameOptionsView: UIView!
    @IBOutlet weak var openInMapsButton: UIButton!
    @IBOutlet weak var addToTripButton: UIButton!
    @IBOutlet weak var pinNameTF: UITextField!
    @IBOutlet weak var addToMapButton: UIButton!
    
    var pinNameOptionsViewShowing = false
    var optionsViewShowing = false
    var matchingItems: [MKMapItem] = []
    var selectedPin: MKPlacemark?
    var selectedPinName: String?
    var selectedAnnotation: MKAnnotation?
    
    
    var spanValue: CLLocationDegrees = 0.05
    let db = Firestore.firestore()
    
    // all annotations will be centralized, per session, in this array, with the purpose of triggering the next one when clicking.
    var currentAnnotations: [MKPointAnnotation] = []
    var placemarkForUserDeclaredPin: MKPlacemark?
    
    var pinImage: String?
//    var customSearchOn = false
    var resultSearchController:UISearchController? = nil
    let locationManager = CLLocationManager()
    var nearbyButtonTapped = false
    
    //MARK: - View did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // must initialize currentANnotations, or pass them from previous controller
        mapView.addAnnotations(currentAnnotations)
        
        //setting nav
//        navigationController!.navigationBar.topItem?.title = "Events"
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
    
        
        if selectedRegion == nil {
        let location = CLLocationCoordinate2D(latitude: 51.50, longitude: 0.12)
        let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)
        selectedRegion = MKCoordinateRegion(center: location, span: span)
        }
        if selectedLocation == nil {
            zoomInOnSelectedRegion()
            
        } else {
            print("PLACEMARK IS ")
            print(selectedLocation)
            dropPinZoomIn(ann: selectedLocation!, zoom: true)
            
        }
        if let safeLocations = allLocations {
            for loc in safeLocations {
                dropPinZoomIn(ann: loc, zoom: true)
            }
        }
        
        
        
        
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
        // Center it around the passed over value of location
//        mapView.centerCoordinate =
        mapView.showsCompass = true
        
        
        // Core location set up
        
      
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func nearbySearchTapped(_ sender: UIButton) {
        nearbyButtonTapped = true
        locationManager.requestWhenInUseAuthorization()
        spanValue = 0.0005
        locationManager.requestLocation()
        // for continuous use startupdating location
        spanValue = 0.05
        print(nearbyButtonTapped)
    }
    
    
    
    // options buttons
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
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        //NOT sure if needed
        //        for ann in currentAnnotations {
        //            print("going here")
        //            if ann.coordinate.longitude <= coordinate.longitude + 0.001 && ann.coordinate.longitude >= coordinate.longitude - 0.001 && ann.coordinate.latitude <= coordinate.latitude + 0.001 && ann.coordinate.latitude >= coordinate.latitude - 0.001 {
        //                print("CLICKING ON ANNOTATIOOOOON")
        //                return
        //            }
        //        }
    }
    
    @IBAction func mapDidPressLong(_ sender: UILongPressGestureRecognizer) {
        //        customSearchOn = true
        pinImage = "mappin.circle"
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let geoLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(geoLoc) { placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                return
            }
            guard let placemarks = placemarks else {
                print("*** Error in \(#function): placemark is nil")
                return
            }
            let placemark = placemarks[0]
            if let areas = placemark.areasOfInterest, areas.count > 0, let name = placemark.name {
                // IT MEANS there's an actual existing place
                self.dropPinZoomIn(placemark: MKPlacemark(placemark: placemark), zoom: false)
                
            } else {
                self.pinNameOptionsView.isHidden = false
                self.placemarkForUserDeclaredPin = MKPlacemark(placemark: placemark)
            }
        }
    }
    
    
    
    func zoomInOnSelectedRegion() {
        if let safeRegion = selectedRegion {
            mapView.setRegion(safeRegion, animated: true)
        }
//            else
//        {
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestLocation()
//
//            if let safeLocation = locationManager.location {
//                let currentLocation = CLLocationCoordinate2D(latitude: safeLocation.coordinate.latitude, longitude: safeLocation.coordinate.longitude)
//                let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
//                let currentRegion = MKCoordinateRegion(center: currentLocation, span: span)
//                mapView.setRegion(currentRegion, animated: true)
//            }
//        }
    }
    
    @IBAction func restaurantsSearch(_ sender: UIButton) {
        customSearch(pinImage: "gift", searchFor: "Restaurants")
        customSearch(pinImage: "bed.double", searchFor: "Coffee & Tea")
    }
    
    @IBAction func lodgingSearch(_ sender: UIButton) {
        customSearch(pinImage: "bed.double.fill", searchFor: "Hotels & Events")
        customSearch(pinImage: "bed.double.fill", searchFor: "Lodging")
        customSearch(pinImage: "bed.double.fill", searchFor: "Rent")
        customSearch(pinImage: "bed.double.fill", searchFor: "Hotel")
    }
    
    @IBAction func touristSearch(_ sender: UIButton) {
        customSearch(pinImage: "camera.fill", searchFor: "Touristic attractions")
    }
    
    
    @IBAction func museumSearch(_ sender: UIButton) {
        customSearch(pinImage: "house.fill", searchFor: "Museums")
    }
    
    
    func customSearch(pinImage image: String, searchFor keyWord: String) {
//        customSearchOn = true
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
    }
    
    
}
extension TripEventsViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse && nearbyButtonTapped == true {
    locationManager.requestLocation()
            nearbyButtonTapped = false
        }
//        else {
//            locationManager.requestLocation()
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let safeLocation = locations.first {
            let location = CLLocationCoordinate2D(latitude: safeLocation.coordinate.latitude, longitude: safeLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
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
        selectedPin = placemark
        // clear existing pins???????
        //         mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name ?? "Destination"
      
        if let city = placemark.locality {
            annotation.subtitle = "\(city)"
        }
        if let state = placemark.administrativeArea {
            annotation.subtitle = "\(state)"
        }
        if let city = placemark.locality, let state = placemark.administrativeArea {
            
            annotation.subtitle = "\(city), \(state)"
//            let code = placemark.countryCode, let country = placemark.country, let areas = placemark.areasOfInterest, let region = placemark.region
        }
        mapView.addAnnotation(annotation)
        currentAnnotations.append(annotation)
        if zoom {
            let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func dropPinZoomIn(ann: MKAnnotation, zoom: Bool) {
       
        let annotation = MKPointAnnotation()
        annotation.coordinate = ann.coordinate
        annotation.title = ann.title ?? "Destination"
        annotation.subtitle = ann.subtitle ?? "No description available"

        
        mapView.addAnnotation(annotation)
        currentAnnotations.append(annotation)
        if zoom {
            let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)
            let region = MKCoordinateRegion(center: ann.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
}

//MARK: - Map View Delegate - handles clicking on annotations
extension TripEventsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
print("DID ADD CALLED")
    for view in views {
        view.tintColor = UIColor(named: K.CorporateColours.teal)
    }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        optionsView.isHidden = false
        if let ann = view.annotation {
//            print("annotation props are \(ann.title) \(ann.subtitle) \(ann.description)")

            selectedPin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: ann.coordinate.latitude, longitude: ann.coordinate.longitude), addressDictionary: ["name": ann.title])
            selectedPinName = ann.title ?? "Your destination"
            selectedAnnotation = ann
        }
    }
    
  
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("AM I IN HERE???????????????????????????")
        
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        
         let annotationView = mapView.view(for: annotation)
//            as? MKPinAnnotationView    {
        print("IS THIS VEING CALLED VIEW FORRRRRRRR")
        print(annotationView?.tintColor)
        annotationView?.tintColor = UIColor(named: K.CorporateColours.teal)
//        annotationView.pinTintColor = UIColor(named: K.CorporateColours.teal)
//            return annotationView
//        }
//
        
        
//        let identifier = "Placemark"
//
//          // attempt to find a cell we can recycle
//          var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//        annotationView?.markerTintColor = UIColor(named: K.CorporateColours.teal)
        
        return annotationView
    }
    
    // https://stackoverflow.com/questions/28604429/how-to-open-maps-app-programmatically-with-coordinates-in-swift
    @objc func getDirections () {
        if let selectedPin = selectedPin {
            let regionDistance:CLLocationDistance = 100
            let regionSpan = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selectedPin.coordinate.latitude, longitude: selectedPin.coordinate.longitude), latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
//            let options = [
//                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
//                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
//            ]
//            let launchOpt2 = [MKLaunchOptionsMapCenterKey : MKLaunchOptionsMapCenterKey]
            let mapItem = MKMapItem(placemark: selectedPin)
            mapItem.name = selectedPinName
            mapItem.openInMaps(launchOptions: nil)
        }
    }
    //MARK: - Add to favourites implementation
    @objc func addToFavourites() {
        
        if let safePin = selectedPin, let safeAnnotation = selectedAnnotation {
//            let location = CLLocation(latitude: safePin.coordinate.latitude, longitude: safePin.coordinate.longitude)
            let gp = GeoPoint(latitude: safePin.coordinate.latitude, longitude: safePin.coordinate.longitude)
            
            var ref: DocumentReference? = nil
            var title = ""
            var sub = ""
            var city = ""
            var state = ""
            
            if let safetitle = safeAnnotation.title  {
                title = safetitle ?? "Place name not available"
            }
            if let safesub = safeAnnotation.subtitle {
                sub = safesub ?? "Description not available"
            }
            
            if let safeCity = safePin.locality {
                city = safeCity
            }
            if let safeState = safePin.administrativeArea {
                state = safeState
            }
            ref = db.collection("locations").addDocument(data: [
                "gp": gp,
                "dateAdded": FieldValue.serverTimestamp(),
                "title": title,
                "subtitle": sub,
                "city": city,
                "state": state,
                
//                "description": safeAnnotation.description,
                "tripID": selectedTrip!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    print(Location(gp: CLLocation(latitude: gp.latitude, longitude: gp.longitude), title: title, subtitle:sub, id: self.selectedTrip!, city: city, state: state))
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

