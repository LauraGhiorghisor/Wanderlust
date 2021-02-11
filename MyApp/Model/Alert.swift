//
//  Alert.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 04/01/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import Foundation
import FirebaseFirestore
struct Alert {
    var ID: String
    var tripID: String
    var receiver: String
    var alertStatus: String
    var sender: String
    var tripName: String
    
//    var user: String
    var dateAdded: Timestamp
    var bgImage: String
    var color: String
    var leader: String
//    var name: String
    var status: String
}
