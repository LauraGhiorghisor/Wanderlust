//
//  TripContentAddParticipantsCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class NewTripAddParticipantsCell: UITableViewCell {
    
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addTF: UITextField!
//    @IBOutlet weak var goButton: UIButton!
    
    let db = Firestore.firestore()
    static var selectedTrip: String? {
        didSet {
            print("ALL SET")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTF.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
//MARK: - TF delegate
extension NewTripAddParticipantsCell: UITextFieldDelegate {
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
//     must send invitation?????????
//     maybe have a drop down for the search
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

//        let partRef = db.collection("trips").document(TripContentAddParticipantsCell.selectedTrip!)
//
//        // Set the "capital" field of the city 'DC'
//        partRef.updateData([
//            "participants": FieldValue.arrayUnion(
//                [
//                    [
//                        "name" : addTF.text!,
//                        "email": "123@gmail.com",
//                        "voters": []
//                    ]
//            ])
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
        if let vc =  self.parentContainerViewController() as? NewTripViewController {
            vc.participants.append(addTF.text!)
//            vc.tableView.frame. += 40
        }
//        NewTripViewController.participants.append(addTF.text!)

        addTF.text = ""
        return true
        
    }
    
}

