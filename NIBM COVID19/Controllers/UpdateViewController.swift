//
//  UpdateViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase

class UpdateViewController: UIViewController {
    
    private let uid = Auth.auth().currentUser?.uid
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private lazy var updateTemperatureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(updateTemperature), for: .touchUpInside)
        return button
    }()
    
    private lazy var createNewsItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create News Item", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(createNewsItem), for: .touchUpInside)
        return button
    }()
    
    private lazy var surveyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Take Survey", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(takeSurvey), for: .touchUpInside)
        return button
    }()
    
    private lazy var lastUpdatedTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
        label.textColor = .black
        label.text = "Checking..."
        return label
    }()
    
    private lazy var lastUpdatedTemperatureDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textColor = .lightGray
        label.text = "Last Updated..."
        return label
    }()
    
    private lazy var temperatureTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Temperature"
        textField.keyboardType = .numberPad
        return textField
    }()

    func fetchUserTemperatureDate(uid: String) {
        Database.database().reference().child(Constants.userHealth).child(uid).child(Constants.userTemperature).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            self.lastUpdatedTemperatureLabel.text = value?["temperature"] as? String
            self.lastUpdatedTemperatureDateLabel.text = value?["modifiedDate"] as? String
            
            self.lastUpdatedTemperatureLabel.text?.append(contentsOf: " °C")
            
            if self.lastUpdatedTemperatureLabel.text == nil {
                self.lastUpdatedTemperatureLabel.text = "Not Updated"
            }
            if self.lastUpdatedTemperatureDateLabel.text == nil {
                self.lastUpdatedTemperatureDateLabel.text = "Last Update: Never"
            }
        }) { (error) in
            print("Error Occurred: \(error.localizedDescription)")
        }
    }
    
    @objc func takeSurvey() {
        let surveyViewController = SurveyViewController()
        navigationController?.pushViewController(surveyViewController, animated: true)
    }
    
    @objc func createNewsItem() {
        let createNewsItemViewController = CreateNewsItemViewController()
        navigationController?.pushViewController(createNewsItemViewController, animated: true)
    }
    
    @objc func updateTemperature() {
        if (temperatureTextField.text?.trimmingCharacters(in: [" "]).isEmpty)! {
            return
        }
        print("Hit")
        spinner.startAnimating()
        let values = ["temperature": temperatureTextField.text!.trimmingCharacters(in: [" "]), "modifiedDate": Date().timeIntervalSince1970] as [String : Any]
        Database.database().reference().child(Constants.userHealth).child(uid!).child(Constants.userTemperature).updateChildValues(values) { (error, ref) in
            if error != nil {
                let alert = UIAlertController(title: "An error occurred", message: "Couldn't save temperature on database", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            self.temperatureTextField.text = ""
            self.spinner.stopAnimating()
            let alert = UIAlertController(title: "Success", message: "Temperature Updated", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil
            ))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        fetchUserTemperatureDate(uid: uid!)
    }
    
    func setupUserInterface() {
        view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        
        view.addSubview(createNewsItemButton)
        createNewsItemButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor , right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10, height: 75)
        
        
        view.addSubview(surveyButton)
        surveyButton.setViewConstraints(top: createNewsItemButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor , right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10, height: 75)
        
        
        view.addSubview(surveyButton)
        
        view.addSubview(lastUpdatedTemperatureLabel)
        view.addSubview(lastUpdatedTemperatureDateLabel)
        view.addSubview(temperatureTextField)
        view.addSubview(updateTemperatureButton)
        
        lastUpdatedTemperatureLabel.setViewConstraints(top: surveyButton.bottomAnchor, marginTop: 20, marginBottom: 10, marginLeft: 10, marginRight: 10)
        lastUpdatedTemperatureLabel.centerX(view: view)
        
        lastUpdatedTemperatureDateLabel.setViewConstraints(top: lastUpdatedTemperatureLabel.bottomAnchor, marginTop: 20, marginBottom: 10, marginLeft: 10, marginRight: 10)
        lastUpdatedTemperatureDateLabel.centerX(view: view)
        
        temperatureTextField.setViewConstraints(top: lastUpdatedTemperatureDateLabel.bottomAnchor, marginTop: 10, marginBottom: 5)
        temperatureTextField.centerX(view: view)
        
        updateTemperatureButton.setViewConstraints(top: temperatureTextField.bottomAnchor, marginTop: 10, width: view.frame.size.width / 3, height: 40)
        updateTemperatureButton.centerX(view: view)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
