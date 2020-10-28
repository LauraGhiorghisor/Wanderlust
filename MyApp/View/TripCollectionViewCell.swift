//
//  TripCollectionViewCell.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 23/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    
    var trip: Trip! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        if let trip = trip {
            bgImageView.image = trip.bgImage
            titleLabel.text = trip.title
            colorView.backgroundColor = trip.color
        } else {
            bgImageView.image = nil
            titleLabel.text = "Nothing yet"
            colorView.backgroundColor = nil
        }
        
        bgImageView.layer.cornerRadius = 15.0
        colorView.layer.cornerRadius = 15.0
        bgImageView.layer.masksToBounds = true
        colorView.layer.masksToBounds = true
    }
    
}
