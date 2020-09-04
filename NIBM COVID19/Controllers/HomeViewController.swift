//
//  HomeViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var stayHomelabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "All you need is\n",  attributes: [.foregroundColor: UIColor.black])
        var secondString = NSMutableAttributedString(string: "stay at home", attributes: [
            .foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)
        ])
        
        firstString.append(secondString)
        let label = UILabel()
        label.attributedText = firstString
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var universityCaseUpdatelabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "University case update",  attributes: [.foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)])
        let label = UILabel()
        label.attributedText = firstString
        return label
    }()
    
    private lazy var infectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Infected")
        return imageView
    }()
    
    private lazy var deathImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Deaths")
        return imageView
    }()
    
    private lazy var notInfectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Not Infected")
        return imageView
    }()
    
    private lazy var infectedCountlabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "3",  attributes: [.foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)])
        let label = UILabel()
        label.attributedText = firstString
        return label
    }()
    
    private lazy var deathCountlabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "0",  attributes: [.foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)])
        let label = UILabel()
        label.attributedText = firstString
        return label
    }()
    
    private lazy var notInfectedCountlabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "15",  attributes: [.foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)])
        let label = UILabel()
        label.attributedText = firstString
        return label
    }()
    
    private lazy var infectedlabel: UILabel = {
        let label = UILabel()
        label.text = "Infected"
        return label
    }()
    
    private lazy var deathlabel: UILabel = {
        let label = UILabel()
        label.text = "Deaths"
        return label
    }()
    
    private lazy var notInfectedlabel: UILabel = {
        let label = UILabel()
        label.text = "Not Infected"
        return label
    }()
    
    private lazy var safeActionsButton: UIButton = {
        let button = UIButton()
        var firstString = NSMutableAttributedString(string: "Safe Actions ",  attributes: [.foregroundColor: UIColor.black])
        var secondString = NSMutableAttributedString(string: "›", attributes: [
            .foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)
        ])
        firstString.append(secondString)
        button.setAttributedTitle(firstString, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
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
    
    @objc func handleSignOut()  {
        let authenticatedUser = Auth.auth()
        do {
            try authenticatedUser.signOut()
            let launchViewController = UINavigationController(rootViewController: LaunchViewController())
            launchViewController.modalPresentationStyle = .fullScreen
            self.present(launchViewController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        
    }
    
    func setupUserInterface() {
        
        //avigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        let safetyActionsStackView = UIStackView(arrangedSubviews: [stayHomelabel, safeActionsButton])
        safetyActionsStackView.axis = .vertical
        safetyActionsStackView.distribution = .fillProportionally
        safetyActionsStackView.spacing = 0
        
        
        let safetyActionsLogoStackView = UIStackView(arrangedSubviews: [logoImageView, safetyActionsStackView])
        safetyActionsLogoStackView.axis = .horizontal
        safetyActionsLogoStackView.distribution = .fillEqually
        safetyActionsLogoStackView.spacing = 20
        
        safetyActionsLogoStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safetyActionsLogoStackView)
        
        safetyActionsLogoStackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        safetyActionsLogoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                        constant: 20).isActive = true
        safetyActionsLogoStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                          constant: -20).isActive = true
        safetyActionsLogoStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                         constant: 20).isActive = true
        
        view.addSubview(signOutButton)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.topAnchor.constraint(equalTo: safetyActionsStackView.bottomAnchor, constant: 20).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
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
