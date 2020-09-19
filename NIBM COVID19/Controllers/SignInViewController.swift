//
//  SignInViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/28/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In with Email"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var needAnAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Need an account?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1), for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(handleNeedAnAccount), for: .touchUpInside)
        return button
    }()
    
    private lazy var popViewControllerButton: UIButton = {
        let button = UIButton()
        button.setTitle("╳", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1), for: .highlighted)
        button.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return button
    }()
    
    @objc func handleNeedAnAccount() {
        if ((navigationController?.viewControllers.count)! > 3) {
            navigationController?.popViewController(animated: true)
        } else {
            let signUpViewController = SignUpViewController()
            navigationController?.pushViewController(signUpViewController, animated: true)
        }
        
    }
    
    @objc func handleSignIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to login user with error \(error)")
                return
            }
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            guard let mainViewController = keyWindow?.rootViewController as? TabBarViewController else { return }
            mainViewController.setupUserInterface()
            mainViewController.tabBar.isHidden = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    func setupUserInterface() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(popViewControllerButton)
        popViewControllerButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, marginTop: 20, marginLeft: 20)
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: popViewControllerButton.bottomAnchor,
                                        constant: 20).isActive = true
        
        let signInStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        signInStackView.axis = .vertical
        signInStackView.distribution = .fillEqually
        signInStackView.spacing = 15
        
        view.addSubview(signInStackView)
        signInStackView.setViewConstraints(top: titleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginLeft: 20, marginRight: 20)
        
        view.addSubview(signInButton)
        signInButton.setViewConstraints(top: signInStackView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 30, marginLeft: 20, marginRight: 20, height: 40)
        
        view.addSubview(needAnAccountButton)
        needAnAccountButton.setViewConstraints(top: signInButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 30, marginLeft: 20, marginRight: 20, height: 40)
    }
}
