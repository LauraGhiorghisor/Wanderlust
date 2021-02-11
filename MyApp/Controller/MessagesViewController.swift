//
//  MessagesViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 26/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase



// make sure we have a case 0 on the messages display
// messages scrolling past top bar  - layout constraint issue - maybe with the msg text field??????
class MessagesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var msgTV: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var newMessage: UITextView!
    @IBOutlet weak var emptyView: UIView!
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    var selectedTrip: String? {
        didSet {
            load()
        }
    }
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTV.dataSource = self
        msgTV.register(UINib(nibName: K.msgNibName, bundle: nil), forCellReuseIdentifier: K.msgCellIdentifier)
        msgTV.delegate = self
        newMessage.delegate = self
        newMessage.layer.cornerRadius =
            newMessage.frame.size.height/5
        newMessage.text = "Write text here..."
        newMessage.textColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }
    
    
    
    func load() {
        db.collection(K.FStore.msgCollectionName)
            .whereField(K.FStore.tripParentField, isEqualTo: selectedTrip!)
            .order(by: K.FStore.dateField)
            .addSnapshotListener() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let queryDocs = querySnapshot?.documents {
                        
                        if queryDocs.count == 0 {
                            DispatchQueue.main.async {
                                self.view.bringSubviewToFront(self.emptyView)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.view.bringSubviewToFront(self.msgTV)
                            }
                            self.messages = []
                            for doc in queryDocs {
                                let data = doc.data()
                                
                                if let sender = data[K.FStore.senderField] as? String, let body = data[K.FStore.bodyField] as? String, let date = data[K.FStore.dateField] as? Timestamp, let trip = data[K.FStore.tripParentField] as? String {
                                    self.messages.append(Message(sender: sender, body: body, trip: trip, date: date))
                                    DispatchQueue.main.async {
                                        self.msgTV.reloadData()
                                        let index = IndexPath(row: self.messages.count-1, section: 0)
                                        self.msgTV.scrollToRow(at: index, at: .top, animated: true)
                                    }
                                }
                            }// end for
                        }//else - count>0
                    }//querydocs
                }//else
            }//listener
    }
    
    @IBAction func send(_ sender: Any) {
        
        if let messageBody = newMessage.text, let messageSender = Auth.auth().currentUser?.email, let parentTrip = selectedTrip {
            if !messageBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                db.collection(K.FStore.msgCollectionName).addDocument(data: [
                    K.FStore.bodyField: messageBody,
                    K.FStore.senderField: messageSender,
                    K.FStore.dateField: Timestamp(date: Date()),
                    K.FStore.tripParentField: parentTrip
                ]) { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        print("Saved data OK")
                        DispatchQueue.main.async {
                            self.newMessage.text = ""
                            self.textViewDidChange(self.newMessage)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.newMessage.text = ""
                    self.textViewDidChange(self.newMessage)
                }
            }
        }
    }
}

//MARK: - Table View data source

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.msgCellIdentifier, for: indexPath) as! MessageCell
        
        cell.msgText.text = messages[indexPath.row].body
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftProfileImage.isHidden = true
            cell.rightProfileImage.isHidden = false
            cell.textBubble.backgroundColor = .systemOrange
            cell.msgText.textColor = .white
            cell.rightProfileImage.tintColor = .systemGray
        } else {
            cell.leftProfileImage.isHidden = false
            cell.rightProfileImage.isHidden = true
            cell.textBubble.backgroundColor = UIColor(named: K.CorporateColours.grey)
            cell.msgText.textColor = .black
            cell.rightProfileImage.tintColor = .systemOrange
        }
        return cell
    }
}



//MARK: - UITextView Delegate
//https://www.youtube.com/watch?v=0Jb29c22xu8

extension MessagesViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimate = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimate.height
            }
        }
    }
    // https://stackoverflow.com/questions/27652227/how-can-i-add-placeholder-text-inside-of-a-uitextview-in-swift
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if newMessage.textColor == UIColor.lightGray {
            newMessage.text = nil
            newMessage.textColor = .label
            
            
            //            let cells = msgTV.visibleCells
            //            var size: CGFloat = 0.0
            //            for cell in cells {
            //                size += cell.frame.size.height
            //            }
            //            print("the size is \(size)")
            //            if messages.count > 0 {
            //            let index = IndexPath(row: 0, section: 0)
            //            if size <= msgTV.frame.size.height/2 {
            //                print("IT IS LESS ")
            
            //                let x = self.msgTV.heightAnchor.constraint(equalToConstant: size)
            //                x.isActive = true
            //                msgTV.setContentOffset(CGPoint(x: self.msgTV.contentOffset.x, y: self.msgTV.contentOffset.y + size), animated: true)
            
            
            //                let hConst = self.msgTV.frame.height - 300
            //                self.msgTV.removeConstraint(self.tvHeight)
            //            self.tvHeight = self.msgTV.heightAnchor.constraint(equalToConstant: hConst)
            //
            //            self.tvHeight.isActive = true
            //            self.msgTV.setContentOffset(CGPoint(x: self.msgTV.contentOffset.x, y: self.msgTV.contentOffset.y + 700), animated: true)
            
            //                msgTV.isScrollEnabled = true
            //                self.msgTV.scrollToRow(at: index, at: .bottom, animated: true)
            //
            //
            //            }
            //            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if newMessage.text.isEmpty {
            newMessage.text = "Write text here..."
            newMessage.textColor = UIColor.lightGray
        }
    }
    
}
