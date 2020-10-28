//
//  TripContentCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 04/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class TripContentAddCell: UITableViewCell {
    
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
        // change per section 
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        addTF.text = df.string(from: sender.date)
        
    }
    
    
    // this will update all cells. 
    @IBAction func goButtonTapped(_ sender: UIButton) {
        sender.viewContainingController()?.performSegue(withIdentifier: K.tripContentToEvents, sender: self)
    }
}



