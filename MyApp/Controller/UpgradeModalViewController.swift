//
//  UpgradeModalViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 26/01/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import StoreKit


class UpgradeModalViewController: UIViewController, SKPaymentTransactionObserver {
    
    
    let purchaseID = "com.lauraghiorghisor.wanderlust.premium"
    let premiumID = "com.lauraghiorghisor.wanderlust.premiumCollaboration"
    let mojiID = "com.lauraghiorghisor.wanderlust.tripmojiaccess"
    
    @IBOutlet weak var nowBtn: UIButton!
    
    @IBOutlet weak var laterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // btns
        nowBtn.layer.cornerRadius = 20.0
        laterBtn.layer.cornerRadius = 20.0
        // Delegate
        SKPaymentQueue.default().add(self)
        
    }
    
    @IBAction func upgradeNowTapped(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: purchaseID)
        
        // create the alert
        let alert = UIAlertController(title: "Purchase Completed", message: "You can now use collaborative features.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
          
        // Payment processing
        //        if SKPaymentQueue.canMakePayments() {
        //            print("user can make payments")
        //
        //            let paymentReq = SKMutablePayment()
        //            paymentReq.productIdentifier = mojiID
        //            SKPaymentQueue.default().add(paymentReq)
        //
        //        } else {
        //            // show msg
        //        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        //        for trans in transactions {
        //
        //              if trans.transactionState == .purchasing {
        //                    print(".purchasing")
        //
        //                } else  if trans.transactionState == .purchased {
        //                    // is successful
        //                    print(".purchased")
        //                    UserDefaults.standard.set(true, forKey: mojiID)
        //                    SKPaymentQueue.default().finishTransaction(trans)
        //
        //                }
        //              else if trans.transactionState == .deferred {
        //                    print(".deferred")
        //
        //                }  else if trans.transactionState == .restored {
        //                    print(".restored")
        //
        //                }else if trans.transactionState == .failed {
        //                    print(".failed")
        //                    if let err = trans.error {
        //                        print (err.localizedDescription)
        //                    }
        //                    SKPaymentQueue.default().finishTransaction(trans)
        //                }
        //
        //            }
        
        //
        //        self.dismiss(animated: true) {
        //            print(UserDefaults.standard.bool(forKey: self.mojiID))
        //        }
    }
    
    
    
    @IBAction func upgradeLaterTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
