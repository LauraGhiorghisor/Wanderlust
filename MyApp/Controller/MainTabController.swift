//
//  MainTabController.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 22/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
       tabBar.unselectedItemTintColor = .white
        tabBarItem.badgeValue = "4"
              
                      let items = tabBar.items
                    for item in items! {
//                        item.badgeColor = UIColor(hue: 0.25, saturation: 1, brightness: 1, alpha: 1)
                        
                        let attributesNormal: [NSAttributedString.Key: Any] = [
                            .foregroundColor: UIColor(named: "\(K.CorporateColours.orange)")!
                            
                        ]
                        let attributesSelected: [NSAttributedString.Key: Any] = [
                            .foregroundColor: UIColor.black
                        ]
                      
                        item.setBadgeTextAttributes(attributesNormal, for: .normal)
                        item.setBadgeTextAttributes(attributesSelected, for: .selected)
                        item.setBadgeTextAttributes(attributesNormal, for: .disabled)
        
        
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
}
