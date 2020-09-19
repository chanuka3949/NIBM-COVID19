//
//  SettingsViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello From Settings"
        return label
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
        return button
    }()
    
    let aboutUs: UIButton = {
        let button = UIButton()
        button.setTitle("Contact Us", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(goToAboutUs), for: .touchUpInside)
        return button
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.setViewConstraints(bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 1)
        return view
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Settings"
        view.backgroundColor = .white
        setupUserInterface()
    }
    
    @objc func handleSignOut()  {
        do {
            try Auth.auth().signOut()
            let launchViewController = UINavigationController(rootViewController: LaunchViewController())
            launchViewController.modalPresentationStyle = .fullScreen
            self.present(launchViewController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc func goToProfile() {
        let profileViewController = UserProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @objc func goToAboutUs() {
        let aboutUsViewController = AboutUsViewController()
        navigationController?.pushViewController(aboutUsViewController, animated: true)
    }
    
    func setupUserInterface() {
        view.addSubview(profileButton)
        profileButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginLeft: 20, height: 40)
        
        view.addSubview(seperatorView)
        seperatorView.setViewConstraints(top: profileButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginLeft: 20, marginRight: 20)
        
        view.addSubview(aboutUs)
        aboutUs.setViewConstraints(top: seperatorView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginLeft: 20, height: 40)
        
        view.addSubview(signOutButton)
        signOutButton.setViewConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10)
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
