//
//  AlertCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 04/01/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class AlertCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    
    let db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    @IBAction func acceptBtnTapped(_ sender: UIButton) {
        
            let user = Auth.auth().currentUser?.email!
            if let controller = sender.viewContainingController() as? AlertsViewController {
                let tv = controller.tableView!
                let alerts = controller.alerts
                let tripID = alerts[tv.indexPath(for: self)!.row].tripID
//                let alertID = alerts[tv.indexPath(for: self)!.row].ID
                let alert = alerts[tv.indexPath(for: self)!.row]
                
//                print("trip is is \(tripID) alertid is \(alertID)")
                
                
                // join trip
                let docRef = db.collection("trips").document(tripID)
                docRef.updateData([
                    "participantsEmailsArray": FieldValue.arrayUnion([user!]),
                    "noParticipants": FieldValue.increment(Int64(1)),
//                    user: FieldValue.serverTimestamp()
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
                
                
                // create thee user trip instance
                let newUserTrip = db.collection("userTrips").document()
                newUserTrip.setData(
                    [
                        "tripID" : tripID,
                        "user": user!,
                        "dateAdded": FieldValue.serverTimestamp(),
                        "bgImage": alert.bgImage,
                        "color": alert.color,
                        "leader": alert.leader,
                        "name": alert.tripName,
                        "status": alert.status
                    ]
                ){ (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        //
                    }
                }
                
                //remove alert from collection
                declineBtnTapped(sender)
            }
    
        
        
    }
    
    
    @IBAction func declineBtnTapped(_ sender: UIButton) {
        
 
        if let controller = sender.viewContainingController() as? AlertsViewController {
            let tv = controller.tableView!
            let alerts = controller.alerts
//            let tripID = alerts[tv.indexPath(for: self)!.row].tripID
            let alertID = alerts[tv.indexPath(for: self)!.row].ID
        
        db.collection("alerts").document(alertID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                DispatchQueue.main.async {
                    tv.reloadData()
                }
                print("Document successfully removed!")
            }
        }
        }
    }
    
}
