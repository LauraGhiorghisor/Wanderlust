//
//  SettingsCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 28/01/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var accessory: UIButton!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
