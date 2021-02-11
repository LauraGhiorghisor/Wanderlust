//
//  Trip.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 22/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class Trip {
    var id = ""
    var title: String
    var bgImage: UIImage
    var color: UIColor
    var status: String
    var leader: String
    
    init(id: String, title: String, bgImage: UIImage, color: UIColor, status: String, leader: String) {
        self.id = id
        self.title = title
        self.bgImage = bgImage
        self.color = color
        self.status = status
        self.leader = leader 
    }
}

