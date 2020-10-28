//
//  RegisterViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 23/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var registerImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Text field delegates
        
        nameTF.delegate = self
        emailTF.delegate = self
        passTF.delegate = self
        confirmPassTF.delegate = self
        
        nameTF.layer.cornerRadius = 15.0
        nameTF.layer.masksToBounds = true
        nameTF.layer.borderColor = UIColor.orange.cgColor
        nameTF.layer.borderWidth = 1.0
        nameTF.addPadding(.left(10))
        emailTF.layer.cornerRadius = 15.0
        emailTF.layer.masksToBounds = true
        emailTF.layer.borderColor = UIColor.orange.cgColor
        emailTF.layer.borderWidth = 1.0
        emailTF.addPadding(.left(10))
        passTF.layer.cornerRadius = 15.0
        passTF.layer.masksToBounds = true
        passTF.layer.borderColor = UIColor.orange.cgColor
        passTF.layer.borderWidth = 1.0
        passTF.addPadding(.left(10))
        confirmPassTF.layer.cornerRadius = 15.0
        confirmPassTF.layer.masksToBounds = true
        confirmPassTF.layer.borderColor = UIColor.orange.cgColor
        confirmPassTF.layer.borderWidth = 1.0
        confirmPassTF.addPadding(.left(10))
        registerBtn.layer.cornerRadius = 15.0
        
        
        registerImageView.layer.cornerRadius = 125
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LoginViewController {
            destinationVC.email = emailTF.text
            destinationVC.password = passTF.text
        }
        
    }
    
    
    
    
    @IBAction func register(_ sender: UIButton) {

        if let email = emailTF.text, let password = passTF.text, let confPass = confirmPassTF.text {
            if (String(password) == String(confPass)) {
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    //            print(authResult?.additionalUserInfo?.providerID)
                    //            print(authResult?.credential?.provider)
                    if let e = error {
                        print(e.localizedDescription)
                        //must add pop with errors
                    } else {
                        print("reg ok")
//                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//
//                            if let e = error {
//                                print(e.localizedDescription)
//                                //must add pop with errors
//                            } else { // navigate to controller
//                                print("log in ok")
//
//                                Auth.auth().currentUser?.sendEmailVerification { (error) in
//                                    if let e = error {
//                                        print("User has not confirmed email", e.localizedDescription)
//                                        // Display an error message saying must confirm email!!!!!!!
//                                    } else {
//                                        print("user has confirmed")
//
//                                        let firebaseAuth = Auth.auth()
//                                        do {
//                                            try firebaseAuth.signOut()
//
//                                        } catch let signOutError as NSError {
//                                            print ("Error signing out: %@", signOutError)
//                                        }
//                                        // go to login page + set up log in and pass data
                        
                        
                        
                        
                        
                        
                        
                        // might need to go straight to trips , user seems to be logged in after registration.
                                       
                                        self.performSegue(withIdentifier: K.registerToLoginSegue, sender: self)
                                        
//                                    }
//                                }
//                            }
//                        }
//                    }
                    
                }
            }
                }
                    else {
                print("not the  same")
            }
        }
        else {
            print("not resigestering")
        
    }

    }
}

//MARK: - TF delegates
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == nameTF {
            emailTF.becomeFirstResponder()
        }
        
        if textField == emailTF {
            passTF.becomeFirstResponder()
        }
        if textField == passTF {
            confirmPassTF.becomeFirstResponder()
        }
        
        if textField == confirmPassTF {
            register(registerBtn)
        }
        return true
    }
   
}
