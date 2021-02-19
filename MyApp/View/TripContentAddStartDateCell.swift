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
    var startDate: Date?
    
    @IBOutlet weak var datePicker: UIDatePicker!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTF.delegate = self
        
//        datePicker.datePickerMode = .date
//        if addTF.text == "" {
//            addTF.inputView = datePicker
//        }
//        else {
//            addTF.inputView = nil
//        }
        
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
//        datePicker.isHidden = true
       
//        if let bgView = datePicker.subviews.first?.subviews.first?.subviews.first {
//
//            bgView.backgroundColor = .clear
//        }
        datePicker.backgroundColor = .clear
        for view in datePicker.subviews {
            view.backgroundColor = .clear
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        df.dateFormat = "dd-MM-yyyy"
//        addTF.text = df.string(from: sender.date)
        startDate = sender.date
        addTF.inputView = nil
        addTF.resignFirstResponder()
        addTF.becomeFirstResponder()
  
    }
    
}

//MARK: - TF delegate
extension TripContentAddStartDateCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        datePicker.isHidden = false
//        return true
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let sdRef = db.collection("trips").document(TripContentAddStartDateCell.selectedTrip!)

//        check if date is ok
//        if (addTF.text != "") {
            sdRef.updateData([
                "startDate": FieldValue.arrayUnion(
                    [
                        [
                            "date" : startDate as Any,
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
            datePicker.datePickerMode = .date
            addTF.inputView = datePicker
            datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
//        } else {
            // input check here toaster to alert of error?
//        }
        addTF.resignFirstResponder()
        datePicker.resignFirstResponder()
//        datePicker.isHidden = true
        return true
        
    }
}
