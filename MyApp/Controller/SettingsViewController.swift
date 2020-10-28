//
//  SettingsViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 21/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//


import UIKit
import Firebase

class SettingsViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    @IBAction func signOut(_ sender: Any) {
        
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("signed out ok")
            //navigationController.poptorootviewcontroller
            //navigationItem.hidesbackbutton
            performSegue(withIdentifier: K.singOutToLogin, sender: self)

        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    

}
