//
//  Location.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 31/12/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
//    var location: CLLocation
//    var dateAdded: Date
    var title: String?
    var subtitle: String?
    var tripID: String
    var city: String
    var state: String
    
    init(gp: CLLocation, title: String, subtitle: String, id: String, city: String, state: String ) {
        self.coordinate = CLLocationCoordinate2D(latitude: gp.coordinate.latitude, longitude: gp.coordinate.longitude)
//        self.dateAdded = dateAdded
        self.title = title
        self.subtitle = subtitle
        self.tripID = id
        self.city = city
        self.state = state
         
        
    }
    
    
}
