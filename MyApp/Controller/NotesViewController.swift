//
//  NotesViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 29/12/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NotesViewController: UIViewController {
    
    @IBOutlet weak var noteView: UITextView!
    
    var selectedTrip: String? {
        didSet {
            
        }
    }
    let db = Firestore.firestore()
    var noteRef: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        load()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if noteRef == nil {

        var ref: DocumentReference? = nil
        ref = db.collection("notes").addDocument(data: [
            "tripID": selectedTrip!,
            "text": noteView.text!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        }
        else {
        
        // update
        let ref = db.collection("notes").document(noteRef!)
        ref.updateData([
            "text": noteView.text!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        }
    }
    
    func load()  {
        
        db.collection("notes").whereField("tripID", isEqualTo: selectedTrip!)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                if  documents.count > 0 {
                    let doc = querySnapshot!.documents[0]
                    self.noteRef = doc.documentID
                    if let text = doc["text"] as? String {
                        DispatchQueue.main.async {
                            self.noteView.text = text
                          
                        }
                    }
            }
            }
    }
    
    @IBAction func editBtnTapped(_ sender: UIBarButtonItem) {
        
        noteView.isEditable = true
        noteView.becomeFirstResponder()
        
    }
    
    
    
}
