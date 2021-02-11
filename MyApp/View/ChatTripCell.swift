//
//  ChatTripCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 22/01/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class ChatTripCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var accessory: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
