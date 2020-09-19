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
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "TabBarHome") , tag: 0)
        UpdateVC.tabBarItem = UITabBarItem(title: "Update", image: #imageLiteral(resourceName: "TabBarUpdates")  , tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "TabBarSettings")  , tag: 2)
        
        let controllerList = [homeVC, UpdateVC, settingsVC]
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
