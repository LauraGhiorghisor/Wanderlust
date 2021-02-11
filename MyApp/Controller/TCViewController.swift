//
//  TCViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/02/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class TCViewController: UIViewController {

    @IBOutlet weak var agreeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        agreeBtn.layer.cornerRadius = 20.0
        
        if UserDefaults.standard.bool(forKey: "T&C") {
        agreeBtn.isEnabled = false
        }
    }
    
    @IBAction func agreeTapped(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "T&C")
    }
    


}
