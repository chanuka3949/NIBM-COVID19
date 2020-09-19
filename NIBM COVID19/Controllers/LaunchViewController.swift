//
//  ViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/20/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up with Email", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString(string: "Already have an account?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.blue]), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAnAccountButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsOfAgreementLabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "By signing up, you agree with the ",  attributes: [.foregroundColor: UIColor.black])
        var secondString = NSMutableAttributedString(string: "Terms of Service ", attributes: [
            .foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        var thirdString = NSMutableAttributedString(string: "and ", attributes: [.foregroundColor: UIColor.black])
        var fourthString = NSMutableAttributedString(string: "Privacy Policy", attributes: [
            .foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        firstString.append(secondString)
        firstString.append(thirdString)
        firstString.append(fourthString)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = firstString
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textAlignment = .center
        return label
    }()
    
    @objc func handleAlreadyHaveAnAccountButton() {
        let signInViewController = SignInViewController()
        navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    @objc func handleSignUp() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    private lazy var popViewControllerButton: UIButton = {
        let button = UIButton()
        button.setTitle("╳", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1), for: .highlighted)
        button.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return button
    }()
    
    @objc func popViewController() {
        if navigationController?.tabBarController?.selectedIndex == 1 {
            navigationController?.tabBarController?.selectedIndex = 0
            navigationController?.tabBarController?.tabBar.isHidden = false
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.tabBarController?.tabBar.isHidden = false
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    func setupUserInterface() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
        
        view.addSubview(popViewControllerButton)
        popViewControllerButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, marginTop: 20, marginLeft: 20)
        
        view.addSubview(logoImageView)
        logoImageView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, marginTop: 50, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.setViewConstraints(top: logoImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 100, marginLeft: 20, marginRight: 20, height: 60)
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.setViewConstraints(top: signUpButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 0, marginLeft: 20, marginRight: 20, height: 60)
        
        view.addSubview(termsOfAgreementLabel)
        termsOfAgreementLabel.setViewConstraints(top: alreadyHaveAnAccountButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 50, marginLeft: 20, marginRight: 20)
    }
    
    
}

