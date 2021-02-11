//
//  ReportProblemViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 09/02/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import MessageUI

class ReportProblemViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var probView: UITextView!
    @IBOutlet weak var subjectTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendBtn.layer.cornerRadius = 20.0
        probView.layer.cornerRadius = 10.0
        
    }
    

    @IBAction func sendTapped(_ sender: UIButton) {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["laura_ghiorghisor@yahoo.com"])
            mail.setSubject(subjectTF.text!)
            mail.setMessageBody(probView.text!, isHTML: false)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       print("i am bein called")
        if let e = error {
            print(e.localizedDescription)
        } else {
            controller.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
