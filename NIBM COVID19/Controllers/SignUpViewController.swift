//
//  SignUpViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/28/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create An Account"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()

    private let termsOfAgreementLabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "By signing up, you agree with the ",  attributes: [.backgroundColor: UIColor.white])
        var secondString = NSAttributedString(string: "Terms of Service ", attributes: [
            .backgroundColor: UIColor.red,
        ])
        var thirdString = NSAttributedString(string: "and ", attributes: [.backgroundColor: UIColor.white])
        var fourthString = NSAttributedString(string: "Privacy Policy", attributes: [
            .backgroundColor: UIColor.red,
        ])
       let val = NSAttributedString(string: "\(firstString) \(secondString) \(thirdString) \(fourthString)")
        
        let label = UILabel()
        label.attributedText = val
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textColor = .black
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        return textField
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Last Name"
        return textField
    }()
    
    private let roleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Role"
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        return button
    }()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Already have an account?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
    }
    
    
    func setupUserInterface() {
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                        constant: 20).isActive = true
        
        let signUpStackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, roleTextField, passwordTextField])
        signUpStackView.axis = .vertical
        signUpStackView.distribution = .fillEqually
        signUpStackView.spacing = 15
        
        view.addSubview(signUpStackView)
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        signUpStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                             constant: 20).isActive = true
        signUpStackView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                               constant: -20).isActive = true
        signUpStackView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                              constant: 20).isActive = true
        
        view.addSubview(signUpButton)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: signUpStackView.bottomAnchor, constant: 30).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: -20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                           constant: 20).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(termsOfAgreementLabel)
                termsOfAgreementLabel.translatesAutoresizingMaskIntoConstraints = false
                
                termsOfAgreementLabel.centerXAnchor.constraint(equalTo:
                    view.centerXAnchor).isActive = true
                termsOfAgreementLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor,
                                                constant: 20).isActive = true
        
        view.addSubview(alreadyHaveAnAccountButton)
        
        alreadyHaveAnAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        alreadyHaveAnAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alreadyHaveAnAccountButton.topAnchor.constraint(equalTo: termsOfAgreementLabel.bottomAnchor, constant: 20).isActive = true
        alreadyHaveAnAccountButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                          constant: -20).isActive = true
        alreadyHaveAnAccountButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                         constant: 20).isActive = true
        alreadyHaveAnAccountButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    
        
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
