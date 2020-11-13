//
//  TripVotedViewController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 12/11/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class TripVotedViewController: UIViewController {

    var selectedTrip: String? {
        // set to nil for new trip?
        
        didSet {
            print("trip set in trip voted VC")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let destinationVC = segue.destination as? TripEventsListViewController {
            destinationVC.selectedTrip = selectedTrip!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
