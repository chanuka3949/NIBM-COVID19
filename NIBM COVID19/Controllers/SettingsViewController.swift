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
    
    var authStateHandler: (Any)? = nil
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
        return button
    }()
    
    let aboutUsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Contact Us", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(goToAboutUs), for: .touchUpInside)
        return button
    }()
    
    let createProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up / Sign In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(goToLaunchScreen), for: .touchUpInside)
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
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc func handleSignOut()  {
        signOutUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        authStateHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser?.uid == nil {
                self.view.subviews.forEach({ $0.removeFromSuperview() })
                self.setupUserInterface()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(authStateHandler as! NSObjectProtocol)
    }
    
    @objc func goToLaunchScreen() {
        let launchViewController = LaunchViewController()
        navigationController?.pushViewController(launchViewController, animated: true)
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
        if (Auth.auth().currentUser?.uid == nil) {
            view.addSubview(createProfileButton)
            createProfileButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginLeft: 20, height: 40)
            view.addSubview(seperatorView)
            seperatorView.setViewConstraints(top: createProfileButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginLeft: 20, marginRight: 20)
        } else {
            view.addSubview(profileButton)
            profileButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginLeft: 20, height: 40)
            view.addSubview(seperatorView)
            seperatorView.setViewConstraints(top: profileButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginLeft: 20, marginRight: 20)
            
            view.addSubview(signOutButton)
            signOutButton.setViewConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10)
        }
        
        view.addSubview(aboutUsButton)
        aboutUsButton.setViewConstraints(top: seperatorView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginLeft: 20, height: 40)
    }
    
}
