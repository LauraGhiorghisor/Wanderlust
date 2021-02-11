//
//  AddParticipantsModalViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/02/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class AddParticipantsModalViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    var selectedTrip: String? {
        didSet {
            load()
        }
        
    }
    var currentTrip: Trip?
    let user = Auth.auth().currentUser?.email
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    let db = Firestore.firestore()
    
    var participants: [String] = [] {
        didSet {
            
            DispatchQueue.main.async {
                print("i am in did set")
                self.tableView.reloadData()
                
                if self.participants.count > 1 {
                    let index = IndexPath(row: self.participants.count, section: 0)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }
                let hConst = self.tableView.frame.height + 44
                self.tableView.removeConstraint(self.tvHeight)
                self.tvHeight = self.tableView.heightAnchor.constraint(equalToConstant: hConst)
                
                self.tvHeight.isActive = true
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y + 44), animated: true)
            }
            
        }
    }
    var initialNumberOfParticipants = 0
    var initialSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendBtn.layer.cornerRadius = 20.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.newTripAddParticipantsNibName , bundle: nil), forCellReuseIdentifier: K.newTripAddParticipantsCellIdentifier)
        
        tableView.register(UINib(nibName: K.newTripShowParticipantsNibName, bundle: nil), forCellReuseIdentifier: K.newTripShowParticipantsCellIdentifier)
        
        
    }
    
    func load() {
        
        db.collection("trips").document(selectedTrip!)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                
                if let part = data["participantsEmailsArray"] as?  Array<String>, let number = data["noParticipants"] as? Int {
                    self.participants = part
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.initialSet == false {
                        self.initialNumberOfParticipants = number
                            self.initialSet = true
                        }
                    }
    }
    
            }
                    
           
                    
        
        print("ENDING LOAD")
        print(initialNumberOfParticipants)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        var invitees = participants
        invitees.removeFirst(initialNumberOfParticipants)
        
        let docRef = db.collection("trips").document(selectedTrip!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    if  let name = data["name"] as? String, let bgImage = data["bgImage"] as? String, let color = data["color"] as? String, let status = data["status"] as? String, let leader = data["leader"] as? String {
              
                        for invitee in invitees {
                            print("invitee for ")
                            print(invitee)
                            let newAlert = self.db.collection("alerts").document()
                            newAlert.setData([
                                "tripID": self.selectedTrip!,
                                "sender": self.user!,
                                "tripName": name,
                                "receiver": invitee,
                                "alertStatus": K.alert.pending,
                                "alertDateAdded": FieldValue.serverTimestamp(),
                                "bgImage": bgImage,
                                "color": color,
                                "leader": leader,
                                "tripStatus": status
                            ]) { (error) in
                                if let e = error {
                                    print(e.localizedDescription)
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }else {
                print("Document does not exist")
            }
        }//get doc end
        
    }
}

//MARK: - Table view Data source
extension AddParticipantsModalViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participants.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.newTripAddParticipantsCellIdentifier, for: indexPath) as! NewTripAddParticipantsCell
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.newTripShowParticipantsCellIdentifier, for: indexPath) as! NewTripShowParticipantsCell
        cell.participantTF.text = self.participants[indexPath.row]
        cell.participantTF.isEnabled = false
        
        return cell
    }
    
    
}

//MARK: - TV delegate

extension AddParticipantsModalViewController: UITableViewDelegate {
    
}

