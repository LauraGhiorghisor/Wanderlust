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

class AlertsViewController: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var alerts: [Alert] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.alertCellNibName, bundle: nil), forCellReuseIdentifier: K.alertCellIdentifier)
        load()
    }
    
    func load() {
        let user = Auth.auth().currentUser?.email
        print(user!)
        db.collection("alerts")
            .whereField("receiver", isEqualTo: user!)
            .order(by: "alertDateAdded", descending: true)
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
                        self.view.bringSubviewToFront(self.tableView)
                    }
                    
                self.alerts = []
                for doc in documents {
                    let data = doc.data()
                    print(data)
                    let docID = doc.documentID
                    
                    if let id = data["tripID"] as? String, let receiver = data["receiver"] as? String, let alertStatus = data["alertStatus"] as? String, let sender = data["sender"] as? String, let name = data["tripName"] as? String, let dateAdded = data["alertDateAdded"] as? Timestamp, let bgImage = data["bgImage"] as? String, let color = data["color"] as? String, let leader = data["leader"] as? String, let tripStatus = data["tripStatus"] as? String {
                        self.alerts.append(Alert(ID: docID, tripID: id, receiver: receiver, alertStatus: alertStatus, sender: sender, tripName: name, dateAdded: dateAdded, bgImage: bgImage, color: color, leader: leader, status: tripStatus))
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }// end for
                }//end else - count > 0
                
                if documents.count == 0 {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
}

//MARK: - TV data source
extension AlertsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.alertCellIdentifier, for: indexPath) as! AlertCell
        let alert = alerts[indexPath.row]
        cell.senderLabel.text = "\(alert.sender)"
        cell.contentLabel.text = "Has invited you to join their trip \(alert.tripName) 🏖"
        return cell
    }
    
    
}

//MARK: - TV Controller
extension AlertsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}

