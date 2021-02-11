//
//  ChatViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 21/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//


import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tripsTV: UITableView!
    var trips: [Trip] = []
    let db = Firestore.firestore()
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tripsTV.dataSource = self
        tripsTV.delegate = self
     
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BrandTeal")
        
        tripsTV.register(UINib(nibName: K.chatTripCellNib , bundle: nil), forCellReuseIdentifier: K.chatTripCellIdentifier)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        load()
    }
    
    // check i dont want real time updates?
    func load() {
        
        if let user = Auth.auth().currentUser?.email {
            db.collection("userTrips")
                .whereField("user", isEqualTo: user)
                .order(by: "dateAdded", descending: true)
                .addSnapshotListener { querySnapshot, error in
                      guard let documents = querySnapshot?.documents else {
                          print("Error fetching documents: \(error!)")
                          return
                      }
                    
                   
                    if documents.count == 0 {
                        DispatchQueue.main.async {
                            self.view.bringSubviewToFront(self.emptyView)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.bringSubviewToFront(self.tripsTV)
                        }
                        self.trips = []
                        for document in documents {
                            let data = document.data()
                            let ref = document.documentID
                            //                            print(data)
                            if let name = data["name"] as? String, let bgImage = data["bgImage"] as? String, let color = data["color"] as? String, let status = data["status"] as? String, let leader = data["leader"] as? String {
                                    
                                    if let finalImage = UIImage(named: bgImage), let finalColor = UIColor(named: color) {
                                        let trip = Trip(id: ref, title: name, bgImage: finalImage, color: finalColor, status: status, leader: leader)
                                        print(trip)
                                        self.trips.append(trip)
                                        DispatchQueue.main.async {
                                            self.tripsTV.reloadData()
                                        }
                                    }
                                }
                            
                        }//end for
                    }//end else - docs > 0
                    }//snapshot
                }
        }
    }

//MARK: - Table View data source

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.chatTripCellIdentifier, for: indexPath) as! ChatTripCell
        cell.content?.text = trips[indexPath.row].title
        return cell
        
    }
    
    
}

//MARK: - Table view delegate
extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.chatToMsg, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MessagesViewController
        
        // get the currently selected category
        if let indexPath = tripsTV.indexPathForSelectedRow {
            destinationVC.selectedTrip = trips[indexPath.row].id
        }        
    }
}


