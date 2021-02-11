//
//  TripContentAddTuneCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class TripContentAddTuneCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
          @IBOutlet weak var addTF: UITextField!
          @IBOutlet weak var goButton: UIButton!
         
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
        addTF.autocapitalizationType = .words
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - TF delegate
extension TripContentAddTuneCell: UITextFieldDelegate {
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
     let tuneRef = db.collection("trips").document(TripContentAddTuneCell.selectedTrip!)
               
               // Set the "capital" field of the city 'DC'
               tuneRef.updateData([
                   "tune": FieldValue.arrayUnion(
                       [
                           [
                               "name" : addTF.text!,
                               "votes": 0,
                               "voters": []
                           ]
                   ])
               ]) { err in
                   if let err = err {
                       print("Error updating document: \(err)")
                   } else {
                       print("Document successfully updated")
                   }
               }
               addTF.text = ""
               
               return true
        
    }
}
