//
//  TripContentAddNameCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 15/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class TripContentAddNameCell: UITableViewCell {
    
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
//MARK: - TF delegate
extension TripContentAddNameCell: UITextFieldDelegate {
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nameRef = db.collection("trips").document(TripContentAddNameCell.selectedTrip!)
        
        // Set the "capital" field of the city 'DC'
        nameRef.updateData([
            "name": FieldValue.arrayUnion(
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
