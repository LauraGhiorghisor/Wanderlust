//
//  UserAccountViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 28/01/2021.
//  Copyright © 2021 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import Firebase

class UserAccountViewController: UIViewController {

    @IBOutlet weak var saveEmailBtn: UIButton!
    @IBOutlet weak var savePasswordBtn: UIButton!
    @IBOutlet weak var tripMojiCollection: UICollectionView!
    
    @IBOutlet weak var currentEmailTF: UITextField!
    @IBOutlet weak var newEmailTF: UITextField!
    @IBOutlet weak var currentPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    let emojis: [UIImage] = [UIImage(named: "bus1")!, UIImage(named: "bus3")!, UIImage(named: "suitcase1")!]
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
print("?????????????????????? ")
        
        print(Auth.auth().currentUser?.displayName)
        // Do any additional setup after loading the view.
        
        saveEmailBtn.layer.cornerRadius = 15.0
        savePasswordBtn.layer.cornerRadius = 15.0
        
        tripMojiCollection.dataSource = self
        tripMojiCollection.delegate = self
        
        tripMojiCollection.register(UINib(nibName: K.bgCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: K.bgCollectionViewCellIdentifier)
    }
    

    @IBAction func changeEmailSave(_ sender: UIButton) {
        print("TAPED EMAIL ")
        if currentEmailTF.text! == user?.email {
        Auth.auth().currentUser?.updateEmail(to: newEmailTF.text!) { (error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                let alert = UIAlertController(title: "All done!", message: "You will now need to authenticate with your new email.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.currentEmailTF.text = ""
                    self.newEmailTF.text = ""
                }))
                self.present(alert, animated: true)
            }
        }
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Please enter your correct current email address and try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.currentEmailTF.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func changePassSave(_ sender: UIButton) {
        print("Tapped pass")
        if currentPassTF.text! == user?.email{
        Auth.auth().currentUser?.updatePassword(to: newPassTF.text!) { (error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                let alert = UIAlertController(title: "All done!", message: "You will now need to authenticate with your new password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.currentPassTF.text = ""
                    self.newPassTF.text = ""
                }))
                self.present(alert, animated: true)
                
            }
        }
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Please enter your correct current email address and try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.currentPassTF.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        }
    }
    
}

//MARK: - Collection view data source
extension UserAccountViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.bgCollectionViewCellIdentifier, for: indexPath) as! BGCollectionViewCell
//        cell.backgroundView = UIImageView(image: emojis[indexPath.row])
        cell.bg.image = emojis[indexPath.row]
        cell.bg.contentMode = .scaleAspectFill
        cell.bg.layer.cornerRadius = 15.0
        if indexPath.row == 0 {
            cell.selectedButton.isHidden = false
        } else {
            cell.selectedButton.isHidden = true
        }
        return cell
    }
}

//MARK: - Collection view delegate

extension UserAccountViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
