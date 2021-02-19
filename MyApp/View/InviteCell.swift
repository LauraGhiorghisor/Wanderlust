//
//  InviteCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 15/02/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class InviteCell: UITableViewCell {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addTF: UITextField!
    
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

extension InviteCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let vc =  self.parentContainerViewController() as? InviteModalViewController {
            vc.participants.append(addTF.text!)
        }
        addTF.text = ""
        return true
    }
}
