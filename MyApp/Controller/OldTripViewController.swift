////
////  NewTripViewController.swift
////  MyApp
////
////  Created by Laura Ghiorghisor on 27/08/2020.
////  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
////
//
//import UIKit
//import Firebase
//import MapKit
//
//class NewTripViewController: UIViewController {
//
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var datePicker: UIDatePicker!
//    @IBOutlet weak var startDateTF: UITextField!
//    
//    var selectedTrip: String? {
//           didSet {
////               load()
//            print(selectedTrip!)
//           }
//       }
//    
//    var dateTapped: Bool = false
//    
//    let db = Firestore.firestore()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
////        view.addGestureRecognizer(UITapGestureRecognizer(target: datePicker, action: #selector(handleDateTap)))
//        
////        let datePicker = UIDatePicker()
////        datePicker.datePickerMode = .date
////        startDateTF.inputView = datePicker
//        
//        writetodb()
//
//    }
//    
//       override func viewWillAppear(_ animated: Bool) {
//           super.viewWillAppear(true)
//           navigationController?.isNavigationBarHidden = false
//       }
//       
//    @IBAction func handleDateTapGesture(_ sender: UITapGestureRecognizer) {
//        print("i am here in the ", "\(String(describing: dateLabel.text))")
////
////       let dp = UIDatePicker()
////        dp.datePickerMode = .date
////
////        if dateTapped {
////
////
////            }
//        
//
//            if self.datePicker.isHidden {
////                self.datePicker.frame.size.height = 115.0
//                self.datePicker.isHidden = false
//                self.datePicker.transform = CGAffineTransform(translationX: 0, y: +100.0)
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
//                      self.datePicker.transform = CGAffineTransform(translationX: 0, y: -0.0)
//                }, completion: { (_) in
//                    //
//                })}  else {
//                UIView.animate(withDuration: 0.5) {
////                      self.datePicker.frame.size.height = 0.0
////                    self.datePicker.transform = CGAffineTransform(translationX: -100.0, y: 0.0)
//                }
//
//                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
//                    self.datePicker.isHidden = true
//                }
//            }
//        
////        if self.datePicker.frame.size.height > CGFloat(0.0){
////             print(self.datePicker.frame.size.height)
////            print("bigger")
////            self.datePicker.frame.size.height = CGFloat(0.0)
////            print(self.datePicker.frame.size.height)
//////            self.datePicker.removeFromSuperview()
////        } else {
////            print("is 0")
////            self.datePicker.frame.size.height = CGFloat(115)
////            print(self.datePicker.frame.size.height)
////        }
////
//        
//    }
//
//    
//    @IBAction func handleMapTapGesture(_ sender: UITapGestureRecognizer) {
//        print("i am in map")
//    }
//    
//    @objc func handleDateTap() {
//        print("i clicked the date picker")
//    }
//    
//    
//    // IMPORTNAT on this we can have a save button to avoid writing to db with every section!!!
//    func writeNewTripTodb() {
//        
////        let coord = CLLocation(latitude: 23, longitude: 23)
////        let geopoint = GeoPoint(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude)
//        // use auth to create user for new trip???
//        
//        db.collection("trips").addDocument(data: [
//            "bgImage": "bg2",
//            "calculated": false,
//            "color": "BrandOrange",
//            "leader": "123@gmail.com",
//            "name" : "new trip",
//            "dateAdded": FieldValue.serverTimestamp(),
//            "participants": [
//                
//                
//            ],
//            "locations": [
//            
//            ],
//            "tune": [
//               
//            ],
//            "startDate": [
//               
//            ],
//            "endDate": [
//               
//            ],
//            "events" : "reference here",
//            
//            
//        ]) { (error) in
//            if let e = error {
//                print(e.localizedDescription)
//            } else {
//                //
//            }
//        }
//    }
//    
//    
//    // add, save the id, and then perform segue
//
//func writetodb() {
//    
//    let coord = CLLocation(latitude: 23, longitude: 23)
//    let geopoint = GeoPoint(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude)
//    // use auth to create user for new trip???
//    
//    db.collection("trips").addDocument(data: [
//        "bgImage": "bg2",
//        "calculated": false,
//        "color": "BrandOrange",
//        "leader": "123@gmail.com",
//        "name" : "Woohoo",
//        "participants": [
//            [
//                "name" : "Laura",
//                "email": "123@gmail.com"
//            ],
//            [
//                "name" : "Mo",
//                "email": "13@gmail.com"
//            ],
//            [
//                "name" : "Paul",
//                "email": "12@gmail.com"
//            ]
//            
//        ],
//        "locations": [
//            [
//                "geolocation": geopoint,
//                "name": "NYC",
//                "votes": 2
//            ],
//            [
//                "geolocation": geopoint,
//                "name": "China",
//                "votes": 2
//            ]
//        ],
//        "tune": [
//            [
//                "name": "I will survive",
//                "votes": 0
//            ],
//            [
//                "name": "I will not survive",
//                "votes": 3
//            ]
//            
//        ],
//        "startDate": [
//            [
//                "date": Timestamp(date: Date()),
//                "votes": 4
//            ],
//            [
//                "date": Timestamp(date: Date()),
//                "votes": 3
//            ]
//        ],
//        "endDate": [
//            [
//                "date": Timestamp(date: Date()),
//                "votes": 4
//            ],
//            [
//                "date": Timestamp(date: Date()),
//                "votes": 3
//            ]
//        ],
//        "events" : "reference here",
//        //            to sort through the trips
//        "dateAdded": FieldValue.serverTimestamp()
//        
//    ]) { (error) in
//        if let e = error {
//            print(e.localizedDescription)
//        } else {
//            //
//        }
//    }
//}
//}
