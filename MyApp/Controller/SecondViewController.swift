//
//  SecondViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 21/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SecondViewController: UIViewController {
    
    let db = Firestore.firestore()
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
}
   
    @IBAction func addcity(_ sender: UIButton) {
    
    }

//  private func setDocumentWithCodable() {
//        // [START set_document_codable]
//        let city = City(name: "Los Angeles",
//                        state: "CA",
//                        country: "USA",
//                        isCapital: false,
//                        population: 5000000)
//
//        do {
//            try db.collection("cities").document("LA").setData(city)
//        } catch let error {
//            print("Error writing city to Firestore: \(error)")
//        }
//        // [END set_document_codable]
//    }
//    
}

