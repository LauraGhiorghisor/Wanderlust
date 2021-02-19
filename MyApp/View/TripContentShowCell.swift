//
//  TripContentShowCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 04/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class TripContentShowCell: UITableViewCell {
    
    //    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemContentLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var itemImage: UIImageView!
    
    let db = Firestore.firestore()
    
    static var selectedTrip: String? {
        didSet {
            print("ALL SET")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func didVote(_ sender: UIButton) {
        
        if let tv = sender.superview?.superview?.superview as? UITableView {
            //            print("Cast as tv?")
            //            print(tv.indexPath(for: self)?.row)
            //            print(tv.indexPath(for: self)?.section)
            
            
            // read the document
            let docRef = db.collection("trips").document(TripContentShowCell.selectedTrip!)
            let user = Auth.auth().currentUser?.email
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        
                        
                        let nameRef = self.db.collection("trips").document(TripContentShowCell.selectedTrip!)
                        // for updates
                        
                        
                        
                        //                        //section 0
                        //                        if tv.indexPath(for: self)?.section == 0 {
                        //                            if var names = data["name"] as? Array<Any> {
                        //                                var name: Dictionary<String, Any>
                        //                                if let n = names[tv.indexPath(for: self)!.row] as? Dictionary<String, Any> {
                        //                                    let finalName = n["name"] as! String
                        //                                    var finalVotes = n["votes"]  as! Int
                        //                                    var finalVoters = n["voters"] as! Array<String>
                        //                                    if !finalVoters.contains(user!) {
                        //                                    finalVotes += 1
                        //                                    finalVoters.append(user!)
                        //                                    name = [
                        //                                        "name": finalName,
                        //                                        "votes": finalVotes,
                        //                                        "voters": finalVoters
                        //
                        //                                    ]
                        //                                    names[tv.indexPath(for: self)!.row] = name
                        //                                    nameRef.updateData([
                        //                                        "name": names
                        //                                    ]) { err in
                        //                                        if let err = err {
                        //                                            print("Error updating document: \(err)")
                        //                                        } else {
                        //                                            print("Document successfully updated")
                        //                                        }
                        //                                        }
                        //                                    } else {
                        //                                        print("user has already voted")
                        //                                    }
                        //                                }
                        //                            }
                        //                        } // end of section
                        
                        //section 2
                        if tv.indexPath(for: self)?.section == 0 {
                            if var names = data["locations"] as? Array<Any> {
                                var name: Dictionary<String, Any>
                                if let n = names[tv.indexPath(for: self)!.row] as? Dictionary<String, Any> {
                                    let finalName = n["name"] as! String
                                    var finalVotes = n["votes"]  as! Int
                                    var finalVoters = n["voters"] as! Array<String>
                                    if !finalVoters.contains(user!) {
                                        finalVotes += 1
                                        finalVoters.append(user!)
                                        name = [
                                            "name": finalName,
                                            "votes": finalVotes,
                                            "voters": finalVoters
                                            
                                        ]
                                        names[tv.indexPath(for: self)!.row] = name
                                        nameRef.updateData([
                                            "locations": names
                                        ]) { err in
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("Document successfully updated")
                                            }
                                        }
                                    } else {
                                        print("user has already voted")
                                    }
                                }
                            }
                        } // end of section
                        
                        //section 3
                        if tv.indexPath(for: self)?.section == 1 {
                            if var names = data["tune"] as? Array<Any> {
                                var name: Dictionary<String, Any>
                                if let n = names[tv.indexPath(for: self)!.row] as? Dictionary<String, Any> {
                                    let finalName = n["name"] as! String
                                    var finalVotes = n["votes"]  as! Int
                                    var finalVoters = n["voters"] as! Array<String>
                                    if !finalVoters.contains(user!) {
                                        finalVotes += 1
                                        finalVoters.append(user!)
                                        name = [
                                            "name": finalName,
                                            "votes": finalVotes,
                                            "voters": finalVoters
                                            
                                        ]
                                        names[tv.indexPath(for: self)!.row] = name
                                        nameRef.updateData([
                                            "tune": names
                                        ]) { err in
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("Document successfully updated")
                                            }
                                        }
                                    } else {
                                        print("user has already voted")
                                    }
                                }
                            }
                        } // end of section
                        
                        
                        //section 4
                        if tv.indexPath(for: self)?.section == 2 {
                            if var names = data["startDate"] as? Array<Any> {
                                var name: Dictionary<String, Any>
                                if let n = names[tv.indexPath(for: self)!.row] as? Dictionary<String, Any> {
                                    let finalName = n["date"] as! Timestamp
                                    var finalVotes = n["votes"]  as! Int
                                    var finalVoters = n["voters"] as! Array<String>
                                    if !finalVoters.contains(user!) {
                                        finalVotes += 1
                                        finalVoters.append(user!)
                                        name = [
                                            "date": finalName,
                                            "votes": finalVotes,
                                            "voters": finalVoters
                                            
                                        ]
                                        names[tv.indexPath(for: self)!.row] = name
                                        nameRef.updateData([
                                            "startDate": names
                                        ]) { err in
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("Document successfully updated")
                                            }
                                        }
                                    } else {
                                        print("user has already voted")
                                    }
                                }
                            }
                        } // end of section
                        
                        //section 5
                        if tv.indexPath(for: self)?.section == 3 {
                            if var names = data["endDate"] as? Array<Any> {
                                var name: Dictionary<String, Any>
                                if let n = names[tv.indexPath(for: self)!.row] as? Dictionary<String, Any> {
                                    let finalName = n["date"] as! Timestamp
                                    var finalVotes = n["votes"]  as! Int
                                    var finalVoters = n["voters"] as! Array<String>
                                    if !finalVoters.contains(user!) {
                                        finalVotes += 1
                                        finalVoters.append(user!)
                                        name = [
                                            "date": finalName,
                                            "votes": finalVotes,
                                            "voters": finalVoters
                                            
                                        ]
                                        names[tv.indexPath(for: self)!.row] = name
                                        nameRef.updateData([
                                            "endDate": names
                                        ]) { err in
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("Document successfully updated")
                                            }
                                        }
                                    } else {
                                        print("user has already voted")
                                    }
                                }
                            }
                        } // end of section
                        
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}
