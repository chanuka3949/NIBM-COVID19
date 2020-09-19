//
//  TabBarViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {
    
    var handle: (Any)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    func setupUserInterface() {
        let homeVC = HomeViewController()
        let UpdateVC = UpdateViewController()
        let settingsVC = SettingsViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "TabBarHome") , tag: 0)
        UpdateVC.tabBarItem = UITabBarItem(title: "Update", image: #imageLiteral(resourceName: "TabBarUpdates")  , tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "TabBarSettings")  , tag: 2)
        
        let controllerList = [homeVC, UpdateVC, settingsVC]
        viewControllers = controllerList.map { UINavigationController(rootViewController: $0) }
    }
}
