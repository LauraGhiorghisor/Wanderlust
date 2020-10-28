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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tripsTV.dataSource = self
        tripsTV.delegate = self
        // set back btn color
        navigationItem.backBarButtonItem?.tintColor = .label
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        load()
    }

    // check i dont want real time updates?
     func load() {
            
        //!!!!!!!!!!! could read this and save it? avoid reading twice for trips and chat? save it locally, if populated?
            if let user = Auth.auth().currentUser?.email {
            db.collection("trips").whereField("participantsEmailsArray", arrayContains: user)
                .getDocuments() { (querySnapshot, err) in
                    self.trips = []
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
//                            print("i am inside document")
//                            print(querySnapshot!.documents.count)
                            let data = document.data()
                            let ref = document.documentID
//                            print(data)
                             if let names = data["name"] as? Array<Any> {
                                                              var title = ""
                                                              if names.count > 0 {
                                                                  if let n = names[0] as? Dictionary<String, Any> {
                                                                      title = n["name"] as! String
                                                                  }
                                                              } else {
                                                                   title = "Upcoming trip"
                                                              }
                                
                            if let bgImage = data["bgImage"] as? String, let color = data["color"] as? String {
                                print(" i am about to form the trip")
                                if let finalImage = UIImage(named: bgImage), let finalColor = UIColor(named: color) {
                                    let trip = Trip(id: ref, title: title, bgImage: finalImage, color: finalColor)
                                print(trip)
                                self.trips.append(trip)
                            DispatchQueue.main.async {
                                self.tripsTV.reloadData()
                            }
                                }
                        }
                            
                            }
                            
                        }
            }
        }
        
    }
        }
}
    //MARK: - Table View data source
    
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tripsCellIdentifier, for: indexPath)
        cell.textLabel?.text = trips[indexPath.row].title
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


