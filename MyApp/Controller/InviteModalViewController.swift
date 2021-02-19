//
//  InviteModalViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 15/02/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class InviteModalViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteBtn: UIButton!
    let user = Auth.auth().currentUser?.email
    var participants: [String] = [] {
        didSet {
            load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       //btn corner radius
        inviteBtn.layer.cornerRadius = 20.0
        //data source
        tableView.dataSource = self
        
        //register cells
        tableView.register(UINib(nibName: K.inviteCellNibName, bundle: nil), forCellReuseIdentifier: K.inviteCellIdentifier)
        tableView.register(UINib(nibName: K.newTripShowParticipantsNibName, bundle: nil), forCellReuseIdentifier: K.newTripShowParticipantsCellIdentifier)
        
        load()
    }
    
    func load() {
        //reload
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func invite(_ sender: UIButton) {
        //send emails
        
//        for invitee in participants {
            sendEmail(inv: participants)
//        }
        
    }
    
    func sendEmail(inv: [String]) {
      
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
        
            mail.mailComposeDelegate = self
            mail.setToRecipients(inv)
            mail.setSubject("You are invited to use Wanderlust")
            mail.setMessageBody("<p>Hello, traveller!</p> <p>You have been invited by \(String(describing: user!)) to download the Wanderlust app!</p><p>You will then be able to join their trips or start planning your own. Great features await you, including real-time voting and chatting!</p><p><a href=\"https://thewanderers.page.link/hello\">Click here to go to app</a></p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            
            let alert = UIAlertController(title: "Oops...", message: "Something went wrong. Make sure you have an active mail account set up on your phone.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
     
        if let e = error {
            let alert = UIAlertController(title: "Oops...", message: "Something went wrong. Please try again!.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                controller.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        } else {
            // must check result
            if result == .failed {
                //alert for failure
                let alert = UIAlertController(title: "Oops...", message: "Something went wrong. Make sure you have an active mail account set up on your phone.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    controller.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                
            } else if result == .sent {
                controller.dismiss(animated: true)
                
                self.dismiss(animated: true, completion: nil)
            } else if result == .cancelled || result == .saved {
                controller.dismiss(animated: true)
            }
            
        }
    }
}

//MARK: - Table view Data source
extension InviteModalViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participants.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.inviteCellIdentifier, for: indexPath) as! InviteCell
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.newTripShowParticipantsCellIdentifier, for: indexPath) as! NewTripShowParticipantsCell
        cell.participantTF.text = self.participants[indexPath.row]
        cell.participantTF.isEnabled = false
        
        return cell
    }
    
    
}
