//
//  Trip.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 22/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class Trip {
    // must also stored whether or not it has been calculated???
    // the vote count should restart if a decision cannot be made? - double tap? should produce a drop down?
    // how to make a toaster?
    var id = ""
    var title: String
    var bgImage: UIImage
    var color: UIColor
    var status: String
    
    init(id: String, title: String, bgImage: UIImage, color: UIColor, status: String) {
        self.id = id
        self.title = title
        self.bgImage = bgImage
        self.color = color
        self.status = status
        
    }
    
//    static func fetchTrips() -> [Trip] {
//        return [
//            Trip(title: "NYC", bgImage: UIImage(named: "bg1")!, color: UIColor(named: "BrandGreen")!),
//            Trip(title: "Spain", bgImage: UIImage(named: "bg2")!, color: .orange),
//        Trip(title: "Iceland", bgImage: UIImage(named: "bg3")!, color: .black),
//        Trip(title: "Buenos Aires", bgImage: UIImage(named: "bg4")!, color: .orange)
//        ]
//    }
}
// read esach section, update it.
// also store the number of total participants and increment it. 
