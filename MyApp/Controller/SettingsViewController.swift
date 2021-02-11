//
//  SettingsViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 21/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//


import UIKit
import Firebase
import StoreKit

class SettingsViewController: UIViewController, SKPaymentTransactionObserver {
  
//    @IBOutlet weak var tableView: UITableView!
    let user = Auth.auth().currentUser?.email

    let purchaseID = "com.lauraghiorghisor.wanderlust.premium"
    
//    @IBOutlet weak var tripMojiCollection: UICollectionView!
//    let emojis: [UIImage] = [UIImage(named: "bus1")!, UIImage(named: "bus3")!, UIImage(named: "suitcase1")!]
//
    var content = [
       
        ["Disable Tips and Suggestions",
        "Terms & Conditions",
        "Report a Problem"],
       
        [ "Share App with Friends"],
        
        ["Upgrade to premium",
        "Restore purchases"],
        
        ["Logged in as",
        "Delete Account"]]
    
    let sections = ["Controlls & Permissions", "Sharing", "Purchases", "User Account"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
  
        tableView.register(UINib(nibName: K.settingsCellNib , bundle: nil), forCellReuseIdentifier: K.settingsCellIdentifier)
        tableView.register(UINib(nibName: K.loggedInCellNib , bundle: nil), forCellReuseIdentifier: K.loggedInCellIdentifier)
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


//MARK: - Table View data source

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel()
        titleLabel.text = sections[section]
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        titleLabel.backgroundColor = .white
        return titleLabel
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fView = UIView()
//        if (view.frame.size.height > 840) {
//            fView.frame.size.height = 20.0
//        } else {
        fView.frame.size.height = 5.0
    
        fView.backgroundColor = .clear
        return fView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return content[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 3 && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: K.loggedInCellIdentifier, for: indexPath) as! LoggedInCell
            cell.content.text = content[indexPath.section][indexPath.row]
                cell.email.text = user
                return cell

        }
            else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.settingsCellIdentifier, for: indexPath) as! SettingsCell
            cell.content.text = content[indexPath.section][indexPath.row]
        
                if indexPath.section == 0  {
                    if indexPath.row == 0 {
            cell.accessory.isHidden = true
            cell.cellSwitch.isHidden = false
                    }
                    if indexPath.row == 2 {
                        cell.accessory.isHidden = false
                    }
        }
                if indexPath.section == 2 {
                    cell.accessory.isHidden = true
                }
                if indexPath.section == 3 && indexPath.row == 1  {
                    cell.accessory.isHidden = true
                }
        return cell
        }
    }
    
    
}

//MARK: - Table view delegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // restore purchase
        if indexPath.row == 1 && indexPath.section == 2 {
            if UserDefaults.standard.bool(forKey: purchaseID) == false {
//            SKPaymentQueue.default().restoreCompletedTransactions()
            UserDefaults.standard.set(true, forKey: purchaseID)
            // create the alert
            let alert = UIAlertController(title: "Purchase Restored", message: "You can now use collaborative features.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "You're all set!", message:  "No unrestored purchases.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        //upgrade
        if indexPath.row == 0 && indexPath.section == 2 {
            if UserDefaults.standard.bool(forKey: purchaseID) == false {
            UserDefaults.standard.set(true, forKey: purchaseID)
            
            // create the alert
            let alert = UIAlertController(title: "Purchase Completed", message: "You can now use collaborative features.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "You have already upgraded.", message: "You can now use collaborative features.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        
        // to user account
        if indexPath.row == 0 && indexPath.section == 3 {
            performSegue(withIdentifier: K.settingsToAccount, sender: self)
        }
        
        if indexPath.row == 1 && indexPath.section == 3 {
            
            
            let alert = UIAlertController(title: "Delete account?", message: "This will delete all your data.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (action) in
                
//                let firebaseAuth = Auth.auth()
//            do {
//              try firebaseAuth.signOut()
//                print("signed out ok")
//                //navigationController.poptorootviewcontroller
//                //navigationItem.hidesbackbutton
//               
//
//            } catch let signOutError as NSError {
//              print ("Error signing out: %@", signOutError)
//            }
              
                
                // delete
                let user = Auth.auth().currentUser
                user?.delete { error in
                  if let error = error {
                    print(error.localizedDescription)
                  } else {
                    // Account deleted.
                    print("Account delered")
                  }
                }
                self.performSegue(withIdentifier: K.singOutToLogin, sender: self)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
            
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            
            performSegue(withIdentifier: K.settingsToReportAProblem, sender: self)
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            
            performSegue(withIdentifier: K.settingsToTC, sender: self)
        }
        
    }


//MARK: - Payment protocol

func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//    for trans in transactions {
//
//       if trans.transactionState == .restored {
//            UserDefaults.standard.set(true, forKey: purchaseID)
//            SKPaymentQueue.default().finishTransaction(trans)
//        }
//    }
}

}
