//
//  CreateNewsItemViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/13/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase

class CreateNewsItemViewController: UIViewController {
    
    private let createNewsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create News Item", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(saveNewsItem), for: .touchUpInside)
        return button
    }()
    
    private let newsItemsTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        textView.layer.borderWidth = 0.5
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        // Do any additional setup after loading the view.
    }
    
    @objc func saveNewsItem() {
        guard newsItemsTextView.text != nil else {
            return
        }
        let currentTimeStamp = String(format:"%.0f", Date().timeIntervalSince1970)
        print(currentTimeStamp)
        Database.database().reference().child(Constants.newsUpdates).child(currentTimeStamp).updateChildValues(["news": newsItemsTextView.text as Any]) { (error, ref) in
            if let error = error {
                print("ERROR: Could not save news item \(error)")
                return
            }
        }
    }
    
    func setupUserInterface() {
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        let newsItemStackView = UIStackView(arrangedSubviews: [newsItemsTextView, createNewsButton])
        newsItemStackView.axis = .vertical
        newsItemStackView.distribution = .fill
        newsItemStackView.spacing = 25
        view.addSubview(newsItemStackView)
        newsItemStackView.translatesAutoresizingMaskIntoConstraints = false
        
        newsItemStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        newsItemStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        newsItemStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        newsItemStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
}
