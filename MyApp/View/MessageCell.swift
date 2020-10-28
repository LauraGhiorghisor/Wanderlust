//
//  MessageCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 27/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {


    @IBOutlet weak var msgText: UILabel!
    @IBOutlet weak var textBubble: UIView!
    @IBOutlet weak var rightProfileImage: UIImageView!
    @IBOutlet weak var leftProfileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textBubble.layer.cornerRadius = textBubble.frame.size.height/5
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
