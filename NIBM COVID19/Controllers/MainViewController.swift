//
//  ViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/20/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

     // MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    private let signUpButton: UIButton = {
          let button = UIButton()
          button.setTitle("Sign Up with Email", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    func setupUserInterface() {
        
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(signUpButton)

        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 100).isActive = true
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


}

