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
    }
    
    @objc func saveNewsItem() {
        guard newsItemsTextView.text != nil else {
            return
        }
        let currentTimeStamp = String(format:"%.0f", Date().timeIntervalSince1970)
        Database.database().reference().child(Constants.newsUpdates).child(currentTimeStamp).updateChildValues(["news": newsItemsTextView.text as Any]) { (error, ref) in
            if let error = error {
                print("ERROR: Could not save news item \(error)")
                let alert = UIAlertController(title: "Error", message: "Couldn't add news item", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            let alert = UIAlertController(title: "Success", message: "News item added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.newsItemsTextView.text = ""
        }
    }
    
    func setupUserInterface() {
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        let newsItemStackView = UIStackView(arrangedSubviews: [newsItemsTextView, createNewsButton])
        newsItemStackView.axis = .vertical
        newsItemStackView.distribution = .fill
        newsItemStackView.spacing = 25
        view.addSubview(newsItemStackView)
        newsItemStackView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginBottom: 20, marginLeft: 20, marginRight: 20)
    }
}
