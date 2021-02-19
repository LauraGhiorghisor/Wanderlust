//
//  LocationSearchTable.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 20/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    var spanValue: CLLocationDegrees = 0.05
    var handleMapSearchDelegate: HandleMapSearch? = nil

    override func viewDidLoad() {
        navigationItem.backButtonTitle = ""
    }
}


extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView!.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.matchingItems.count)
        }  
    }
}

//MARK: - Data Source
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("the source data methods are being called")
        return matchingItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        return cell
        
    }
    
    func parseAddress(_ selectedItem: MKPlacemark) -> String {
      
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

//MARK: - UITableViewDelegate

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        let location = CLLocationCoordinate2D(latitude: selectedItem.coordinate.latitude, longitude: selectedItem.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: self.spanValue, longitudeDelta: self.spanValue)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView!.setRegion(region, animated: true)
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem, zoom: true)
        dismiss(animated: true, completion: nil)
        }
    }


