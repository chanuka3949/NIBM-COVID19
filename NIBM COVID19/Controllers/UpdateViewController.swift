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
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello From Update"
        return label
    }()
    
    private lazy var surveyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Take Survey", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(takeSurvey), for: .touchUpInside)
        return button
    }()
    
    @objc func takeSurvey() {
        let surveyViewController = SurveyViewController()
        navigationController?.pushViewController(surveyViewController, animated: true)
    }
    
    private lazy var createNewsItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create News Item", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(createNewsItem), for: .touchUpInside)
        return button
    }()
    
    @objc func createNewsItem() {
        let createNewsItemViewController = CreateNewsItemViewController()
        navigationController?.pushViewController(createNewsItemViewController, animated: true)
    }
    
    private lazy var updateTemperatureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(updateTemperature), for: .touchUpInside)
        return button
    }()
    
    @objc func updateTemperature() {
        guard temperatureTextField.text != nil else {
            return
        }
        spinner.startAnimating()
        let values = ["temperature": temperatureTextField.text!, "modifiedDate": Date().timeIntervalSince1970] as [String : Any]
        Database.database().reference().child(Constants.userHealth).child(uid!).child(Constants.userTemperature).updateChildValues(values) { (error, ref) in
            if error != nil {
                let alert = UIAlertController(title: "An error occurred", message: "Couldn't save temperature on database", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            self.spinner.stopAnimating()
            let alert = UIAlertController(title: "Success", message: "Temperature Updated", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil
            ))
            self.present(alert, animated: true)
        }
    }
    
    private lazy var lastUpdatedTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    private lazy var lastUpdatedTemperatureDateLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
           label.textColor = .black
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
        Database.database().reference().child(Constants.userHealth).child(uid).child(Constants.userTemperature).observeSingleEvent(of: .value, with: { (snapshot) in
            self.lastUpdatedTemperatureLabel.text = snapshot.value(forKey: "temperature") as? String
            self.lastUpdatedTemperatureDateLabel.text = snapshot.value(forKey: "modifiedDate") as? String
          }) { (error) in
            print("Error Occurred: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.isHidden = true
        
        
        let stackView = UIStackView(arrangedSubviews: [createNewsItemButton, surveyButton, lastUpdatedTemperatureLabel, temperatureTextField, updateTemperatureButton])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        //        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //        view.addSubview(label)
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        //        label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        // Do any additional setup after loading the view.
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
