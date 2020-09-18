//
//  SettingsViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

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
    
    let contactUsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Contact Us", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.setViewConstraints(bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Settings"
        view.backgroundColor = .white
        setupUserInterface()
        // Do any additional setup after loading the view.
    }
    
    @objc func goToProfile() {
        let profileViewController = UserProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func setupUserInterface() {
        view.addSubview(profileButton)
        profileButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginLeft: 20, height: 40)
        
        view.addSubview(seperatorView)
        seperatorView.setViewConstraints(top: profileButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginLeft: 20, marginRight: 20)
        
        view.addSubview(contactUsButton)
        contactUsButton.setViewConstraints(top: seperatorView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginLeft: 20, height: 40)
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
