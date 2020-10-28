//
//  TripContentAddStartDateCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class TripContentAddStartDateCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addTF: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    let db = Firestore.firestore()
    let df = DateFormatter()
    static var selectedTrip: String? {
        didSet {
            print("ALL SET")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTF.delegate = self
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = UIColor.systemOrange
        datePicker.backgroundColor = UIColor.systemOrange
        addTF.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        df.dateFormat = "dd-MM-yyyy"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {

        addTF.text = df.string(from: sender.date)
    }
    
}

//MARK: - TF delegate
extension TripContentAddStartDateCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let sdRef = db.collection("trips").document(TripContentAddStartDateCell.selectedTrip!)
        if let date = df.date(from: addTF.text!) {
            sdRef.updateData([
                "startDate": FieldValue.arrayUnion(
                    [
                        [
                            "date" : date,
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
        } else {
            // input check here toaster to alert of error?
        }
        return true
        
    }
}
