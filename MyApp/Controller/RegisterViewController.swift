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
//        if let destinationVC = segue.destination as? LoginViewController {
//            print("IN prepare")
//            print(Auth.auth().currentUser?.displayName)
//            destinationVC.email = emailTF.text
//            destinationVC.password = passTF.text
//        }
        
    }
    
    
    
    
    @IBAction func register(_ sender: UIButton) {
        
        if emailTF.text! != "" && passTF.text! != "" && passTF.text! != "" && confirmPassTF.text! != "" {
            if emailTF.text!.contains("@") {
                if (passTF.text!.count >= 6) {
                    if passTF.text! == confirmPassTF.text! {
                        Auth.auth().createUser(withEmail: emailTF.text!, password: passTF.text!) { authResult, error in
                            
                            if let e = error {
                                print(e.localizedDescription)
                            } else {
                                print("in register - updatign the user profile")
                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = self.nameTF.text!
                                changeRequest?.commitChanges { (error) in
                                  // ...
                                }
                                
                                
                                self.performSegue(withIdentifier: K.registerToTrips, sender: self)
                            }
                        }
                    }
                    else {
                        // passowrds don't match
                        let alert = UIAlertController(title: "Oops...", message: "Your passwords do not match. Please try again!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            return
                        }))
                        self.present(alert, animated: true)
                    }
                } else {
                    // pass must be longer than 6 characters
                    let alert = UIAlertController(title: "Oops...", message: "Your password must be at least 6 characters long. Please try again!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        return
                    }))
                    self.present(alert, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Oops...", message: "The email address is badly formatted. Please try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    return
                }))
                self.present(alert, animated: true)
            }
        }
        else {
            // must fill in fields
            let alert = UIAlertController(title: "Oops...", message: "Some fields are empty. Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                return
            }))
            self.present(alert, animated: true)
        }
        
//        print(Auth.auth().currentUser?.displayName)
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
