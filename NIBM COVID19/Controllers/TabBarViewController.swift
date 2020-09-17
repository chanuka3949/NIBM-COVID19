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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuthStatus()
        LocationHandler.sharedInstance.getLocationServicePermission()
    }
    
    func checkUserAuthStatus(){
        if Auth.auth().currentUser != nil {
            setupUserInterface()
        } else {
            DispatchQueue.main.async {
                let launchViewController = UINavigationController(rootViewController: LaunchViewController())
                launchViewController.modalPresentationStyle = .fullScreen
                self.present(launchViewController, animated: false, completion: nil)
            }
            
        }
    }
    
    func setupUserInterface() {
        let homeVC = HomeViewController()
        let UpdateVC = UpdateViewController()
        let settingsVC = SettingsViewController()

        
        homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        UpdateVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        settingsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        
        let controllerList = [homeVC, UpdateVC, settingsVC]
//        viewControllers = controllerList
        viewControllers = controllerList.map { UINavigationController(rootViewController: $0) }
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
