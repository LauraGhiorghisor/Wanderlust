//CLTypingLabel
//  TitleViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 28/09/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
//import CLTypingLabel


class TitleViewController: UIViewController {

    
    @IBOutlet weak var appTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitleLabel.text = ""
               let myTitle = "WANDERLUST"
               var int = 0.0
               for ch in myTitle {
                   Timer.scheduledTimer(withTimeInterval: 0.1 * int, repeats: false) { (timer) in
                       self.appTitleLabel.text?.append(ch)
                   }
                   int += 1
               }
//       performSegue(withIdentifier: "Go", sender: self)
        // Do any additional setup after loading the view.
        
        _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
            self.performSegue(withIdentifier: "Go", sender: self)

        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
