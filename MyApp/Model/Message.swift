//
//  Message.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 26/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Message {
    
    let sender: String
    let body: String
    let trip: String
    let date: Timestamp
}
 
