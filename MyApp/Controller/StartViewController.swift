//
//  StartViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 25/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
//import CLTypingLabel

class StartViewController: UIViewController {
//    @IBOutlet weak var appTitleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        appTitleLabel.text = K.appTitle
        
//        appTitleLabel.text = ""
//        let myTitle = "WANDERLUST"
//        var int = 0.0
//        for ch in myTitle {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * int, repeats: false) { (timer) in
//                self.appTitleLabel.text?.append(ch)
//            }
//            int += 1
//        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? NewTripViewController {
//            self.dismiss(animated: false, completion: nil)
            
        }
    }
//    func segue

}
