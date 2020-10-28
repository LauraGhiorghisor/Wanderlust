//
//  LoginViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 23/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//



//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let TabViewController  = storyBoard.instantiateViewController(withIdentifier: "tabs") as! MainTabController
//        TabViewController.modalPresentationStyle = .fullScreen
//        self.present(TabViewController, animated: true, completion: nil)


import UIKit
import Firebase

// just save email and password locally???? and thats it. and then populate the tfs
// MUST USE FOCUS CHANGE ON NEXT TF 
class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var loginImageView: UIImageView!
    
     var email: String? = nil
     var password: String? = nil
    
    
    override func viewDidLoad() {
        
//        print("AM I SIGNED IN????????")
//        print(Auth.auth().currentUser?.email)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTF.layer.cornerRadius = 15.0
        emailTF.layer.masksToBounds = true
        emailTF.layer.borderColor = UIColor.orange.cgColor
        emailTF.layer.borderWidth = 1.0
//        let border = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 20)
//        usernameTF.bounds.inset(by: border)
         emailTF.addPadding(.left(10))
        passwordTF.layer.cornerRadius = 15.0
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.borderColor = UIColor.orange.cgColor
        passwordTF.layer.borderWidth = 1.0
        passwordTF.addPadding(.left(10))
        loginButton.layer.cornerRadius = 15.0
        loginButton.frame.size.height = 75.0
        loginButton.frame.size.width = 230.0
        
        rememberSwitch.frame.size = CGSize(width: 15, height: 14)
        
        // set tf delegates
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // Populate the email and password based on user preferences or register
        if email != nil && password != nil {
            emailTF.text = email
            passwordTF.text = password
        } else {
      
            emailTF.text = "laura_ghiorghisor@yahoo.com"
            passwordTF.text = "123456"
        }
        
        
        
        // image
        
        loginImageView.layer.cornerRadius = 20
        
       
    }
    
    @IBAction func register(_ sender: UIButton) {
    }
    
    @IBAction func forgotPass(_ sender: UIButton) {
        
        Auth.auth().sendPasswordReset(withEmail: "laura_ghiorghisor@yahoo.com") { (err) in
            print("god knows")
            
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
      
        
        if let safeEmail = emailTF.text, let safePass = passwordTF.text {
        
        Auth.auth().signIn(withEmail: safeEmail, password: safePass) { authResult, error in
//          guard let strongSelf = self else { return }
            if let e = error {
                           print("this is the error/n")
                           print(e.localizedDescription)
                           //must add pop with errors
                       } else {
                       // navigate to controller
                       print("log in ok")

                self.performSegue(withIdentifier: K.loginToTabs, sender: self)


        }
                }
        
        } else {
            print("please fill in")
        }
//        Auth.auth().currentUser?.sendEmailVerification { (error) in
//            if let e = error {
//                print("User has not confirmed email")
//            } else {
//                print("user has confirmed")
//            }
//        }
    
}
}

//MARK: - TFDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MUST DO VALIDATION
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        }
        if textField == passwordTF {
            passwordTF.resignFirstResponder()
            login(loginButton)
        }
        return true
    }
}
