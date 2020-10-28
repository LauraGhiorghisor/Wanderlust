//
//  TripContentAddLocationCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class TripContentAddLocationCell: UITableViewCell {

    
       @IBOutlet weak var addButton: UIButton!
       @IBOutlet weak var addTF: UITextField!
       @IBOutlet weak var goButton: UIButton!
      
        static var valueForSegue = ""
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


    @IBAction func goButtonTapped(_ sender: UIButton) {
//        TripContentAddLocationCell.valueForSegue = addTF.text!
//    sender.viewContainingController()?.performSegue(withIdentifier: K.tripContentToLocation, sender: self)
    }
    
    
    
}
//MARK: - TF delegate
extension TripContentAddLocationCell: UITextFieldDelegate {
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
         textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
let locRef = db.collection("trips").document(TripContentAddLocationCell.selectedTrip!)
     
     // Set the "capital" field of the city 'DC'
     locRef.updateData([
         "locations": FieldValue.arrayUnion(
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
