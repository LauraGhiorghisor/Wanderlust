//
//  LoginViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 23/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//


import UIKit
import Firebase
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var appleSignInView: UIStackView!
    var appleLogIn = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    
    var email: String? = nil
     var password: String? = nil

    @IBOutlet weak var topConstr: NSLayoutConstraint!
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTF.frame.size.height = 40.0
        emailTF.layer.cornerRadius = 20.0
        emailTF.layer.masksToBounds = true
        emailTF.layer.borderColor = UIColor.orange.cgColor
        emailTF.layer.borderWidth = 1.0
         emailTF.addPadding(.left(10))
        passwordTF.frame.size.height = 40.0
        passwordTF.layer.cornerRadius = 20.0
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.borderColor = UIColor.orange.cgColor
        passwordTF.layer.borderWidth = 1.0
        passwordTF.addPadding(.left(10))
        loginButton.layer.cornerRadius = 20.0
        loginButton.frame.size.height = 40.0
//        loginButton.frame.size.height = 75.0
//        loginButton.frame.size.width = 230.0
        
//        appleSignInView.layer.cornerRadius = .0
        
        rememberSwitch.frame.size = CGSize(width: 15, height: 14)
        
        // set tf delegates
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // Populate the email and password based on user preferences or register
        
        email = UserDefaults.standard.string(forKey: "userEmail")
        password = UserDefaults.standard.string(forKey: "userPassword")
        
        if email != nil && password != nil {
            emailTF.text = email
            passwordTF.text = password
        }
//            else
//        {
//
//            emailTF.text = "lala"
//            passwordTF.text = "123456"
//        }

        loginImageView.layer.cornerRadius = 20
        
        setupProviderLoginView()
        
        if (view.frame.size.height > 840) {
            topConstr.constant = 100.0
            view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        performExistingAccountSetupFlows()
    }

    
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        if sender.state == .selected {
            print("selected")
        } else if sender.state == .normal {
            print("not selected ")
        }
    }
    
    @IBAction func forgotPass(_ sender: UIButton) {
        
        Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { (err) in
            if let e = err {
                print(e.localizedDescription)
                let alert = UIAlertController(title: "Oops...", message: "You must enter a valid email address!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                //alert
                let alert = UIAlertController(title: "All done!", message: "An email has been sent to \(self.emailTF.text!)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
      
        
        if let safeEmail = emailTF.text, let safePass = passwordTF.text {
        
        Auth.auth().signIn(withEmail: safeEmail, password: safePass) { authResult, error in

            if let e = error {
                           print(e.localizedDescription)
                           //add alert
                let alert = UIAlertController(title: "Oops...", message: "The details you entered are incorrect. Try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    return
                }))
                self.present(alert, animated: true)
                       } else {
                       // navigate to controller
                       print("log in ok")
                        
                        if self.rememberSwitch.isOn {
                        UserDefaults.standard.set(safeEmail, forKey: "userEmail")
                        UserDefaults.standard.set(safePass, forKey: "userPassword")
                            
                        } else if self.rememberSwitch.isOn == false {
                            
                            UserDefaults.standard.removeObject(forKey: "userEmail")
                            UserDefaults.standard.removeObject(forKey: "userPassword")
                            
                        }
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




//MARK: - Apple id sign in

extension LoginViewController {
func setupProviderLoginView() {
  
    if self.traitCollection.userInterfaceStyle == .dark {
       appleLogIn = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .white)

    } else if self.traitCollection.userInterfaceStyle == .light {
           appleLogIn = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
    appleLogIn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    appleLogIn.cornerRadius = 20.0
    appleLogIn.frame.size.height = 40.0
    self.appleSignInView.addArrangedSubview(appleLogIn)

}

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//            super.traitCollectionDidChange(previousTraitCollection)
//
//        if self.traitCollection.userInterfaceStyle == .dark {
//            appleLogIn.overrideUserInterfaceStyle = .light
//        } else  if self.traitCollection.userInterfaceStyle == .light {
//            appleLogIn.overrideUserInterfaceStyle = .dark
//        }
//        }
    
    
    
    
// - Tag: perform_appleid_password_request
/// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
//func performExistingAccountSetupFlows() {
//    // Prepare requests for both Apple ID and password providers.
//    let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                    ASAuthorizationPasswordProvider().createRequest()]
//
//    // Create an authorization controller with the given requests.
//    let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//    authorizationController.delegate = self
//    authorizationController.presentationContextProvider = self
//    authorizationController.performRequests()
//}

    
@available(iOS 13, *)
@objc func handleAuthorizationAppleIDButtonPress() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }



// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}
}


//MARK: - Sign in with Apple delegate
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization

      func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
                print(error?.localizedDescription)
              return
            }
            // User is signed in to Firebase with Apple.
            self.performSegue(withIdentifier: K.loginToTabs, sender: self)

          }
        }
      }

      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
      }

    
    
//    private func saveUserInKeychain(_ userIdentifier: String) {
//        do {
//            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
//    }
//
//    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
//        guard let viewController = self.presentingViewController as? ResultViewController
//            else { return }
//
//        DispatchQueue.main.async {
//            viewController.userIdentifierLabel.text = userIdentifier
//            if let givenName = fullName?.givenName {
//                viewController.givenNameLabel.text = givenName
//            }
//            if let familyName = fullName?.familyName {
//                viewController.familyNameLabel.text = familyName
//            }
//            if let email = email {
//                viewController.emailLabel.text = email
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
        
//        print(userIdentifier)
//    }
    
//    private func showPasswordCredentialAlert(username: String, password: String) {
//        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
//        let alertController = UIAlertController(title: "Keychain Credential Received",
//                                                message: message,
//                                                preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
    
}



extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}





//MARK: - General extension
//extension UIViewController {
//    
//    func showLoginViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
//            loginViewController.modalPresentationStyle = .formSheet
//            loginViewController.isModalInPresentation = true
//            self.present(loginViewController, animated: true, completion: nil)
//        }
//    }
//}
