//
//  UpdateViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import LocalAuthentication

class UpdateViewController: UIViewController {
    
    private let uid = Auth.auth().currentUser?.uid
    private let databaseRef = Database.database().reference()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let authContext = LAContext()
    private var error: NSError?
    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    private var resultList = [UserHealth]()
    private var user = UserHealth(context: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext)
    private var lastUpdatedMoreThanADayAgo: Bool = true
    
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
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textColor = .lightGray
        label.text = "Last Updated..."
        return label
    }()
    
    private lazy var temperatureTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Temperature °C"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    func fetchUserTemperatureDate(uid: String) {
        databaseRef.child(Constants.userHealth).child(uid).child(Constants.userTemperature).observe(.value, with: { [weak self] (snapshot) in
            let value = snapshot.value as? NSDictionary
            let formattedDate: DateFormatter = {
                let date = DateFormatter()
                date.timeStyle = .none
                date.dateStyle = .short
                return date
            }()
            if value?["temperature"] != nil {
                self?.lastUpdatedTemperatureLabel.text = String(format: "%.1f", value?["temperature"] as! Float)
                self?.lastUpdatedTemperatureLabel.text?.append(contentsOf: " °C")
                self?.lastUpdatedTemperatureDateLabel.text = formattedDate.string(from: Date(timeIntervalSince1970: value?["modifiedDate"] as! TimeInterval))
                if let lastUpdatedTime = value?["modifiedDate"] as? Double {
                    if ((Date().timeIntervalSince1970 - lastUpdatedTime) >= 86400) {
                        self?.lastUpdatedMoreThanADayAgo = true
                    } else {
                        self?.lastUpdatedMoreThanADayAgo = false
                    }
                }
            }
            
            if self?.lastUpdatedTemperatureLabel.text == nil || self?.lastUpdatedTemperatureLabel.text == "Checking..." {
                self?.lastUpdatedTemperatureLabel.text = "Not Updated"
            }
            if self?.lastUpdatedTemperatureDateLabel.text == nil || self?.lastUpdatedTemperatureDateLabel.text == "Last Updated..." {
                self?.lastUpdatedTemperatureDateLabel.text = "Last Update: Never"
            }
        }) { (error) in
            print("Error Occurred: \(error.localizedDescription)")
        }
    }
    
    @objc func takeSurvey() {
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "You are trying to change personal data"
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        let surveyViewController = SurveyViewController()
                        self?.navigationController?.pushViewController(surveyViewController, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Face ID Unavailable", message: "Your device is not configured for Apple Face ID", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @objc func createNewsItem() {
        let createNewsItemViewController = CreateNewsItemViewController()
        navigationController?.pushViewController(createNewsItemViewController, animated: true)
    }
    
    @objc func updateTemperature() {
        if !validateTemperature(temp: temperatureTextField.text!) {
            presentAlert(title: "Warning", message: "Please enter a valid temperature value", actionTitle: "OK", currentVC: self)
            temperatureTextField.text? = ""
            return
        }
        if lastUpdatedMoreThanADayAgo == false {
            presentAlert(title: "Cannot update temperature", message: "You can only update the temperature once per day", actionTitle: "OK", currentVC: self)
            temperatureTextField.text? = ""
            return
        }
        let tempValue: String = (temperatureTextField.text?.trimmingCharacters(in: [" "]))!
        guard let temp = Float(tempValue) else {
            presentAlert(title: "Warning", message: "Please enter a valid temperature value", actionTitle: "OK", currentVC: self)
            temperatureTextField.text? = ""
            return
        }
        let riskLevel = calculateRiskLevelByTemp(uid: uid!, temperature: temp)
        user.uid = uid
        user.riskLevel = riskLevel
        user.modifiedDate = Date()
        do {
            spinner.startAnimating()
            try context.save()
            let values = ["temperature": temp, "modifiedDate": Date().timeIntervalSince1970] as [String : Any]
            databaseRef.child(Constants.userHealth).child(uid!).child(Constants.userTemperature).updateChildValues(values) { (error, ref) in
                if error != nil {
                    self.presentAlert(title: "An error occurred", message: "Couldn't save temperature on database", actionTitle: "OK", currentVC: self)
                }
                self.databaseRef.child(Constants.userHealth).child(Constants.surveySummary).child(self.uid!).updateChildValues(["riskLevel":riskLevel]) { (error, ref) in
                    if error != nil {
                        let alert = UIAlertController(title: "An error occurred", message: "Couldn't save survey summary on database", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    self.temperatureTextField.text = ""
                    self.spinner.stopAnimating()
                    self.self.presentAlert(title: "Success", message: "Temperature Updated", actionTitle: "OK", currentVC: self)
                }
            }
        } catch {
            self.spinner.stopAnimating()
            self.presentAlert(title: "An error occurred", message: "Couldn't update temperature", actionTitle: "OK", currentVC: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInterface()
        if(Auth.auth().currentUser?.uid != nil) {
            fetchUserTemperatureDate(uid: uid!)
        } else {
            let launchViewController = LaunchViewController()
            self.navigationController?.pushViewController(launchViewController, animated: true)
        }
    }
    
    func getUserRole(uid: String, completion: @escaping(Role) -> Void) {
        databaseRef.child(Constants.users).child(uid).observeSingleEvent(of: .value, with: {snapshot in
            let value = snapshot.value as? NSDictionary
            let role = value?["role"] as? Int ?? 0
            completion(Role(rawValue: role)!)
        })
    }
    
    func calculateRiskLevelByTemp(uid: String, temperature: Float) -> Int16 {
        var riskLevel: Int16 = 0
        var previousRiskLevel: Int16 = 0
        
        if temperature > 38 {
            riskLevel = 5
        } else if temperature == 38 {
            riskLevel = 3
        } else {
            riskLevel = 1}
        
        let filterPredicate = NSPredicate(format: "uid == %@"
            , uid)
        let sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        let request: NSFetchRequest<UserHealth> = UserHealth.fetchRequest()
        request.predicate = filterPredicate
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1
        do {
            resultList = try context.fetch(request)
            if resultList.count != 0 {
                previousRiskLevel = resultList[0].riskLevel
            }
        } catch {
            print("DEBUG: Error fecthing data from context \(error)")
        }
        riskLevel = (riskLevel + previousRiskLevel) / 2
        return riskLevel
    }
    
    func setupUserInterface() {
        navigationController?.navigationBar.topItem?.title = "Updates"
        view.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        
        view.addSubview(createNewsItemButton)
        view.addSubview(surveyButton)
        view.addSubview(lastUpdatedTemperatureLabel)
        view.addSubview(lastUpdatedTemperatureDateLabel)
        view.addSubview(temperatureTextField)
        view.addSubview(updateTemperatureButton)
        
        createNewsItemButton.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor , right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10, height: 75)
        
        if(Auth.auth().currentUser?.uid != nil) {
            getUserRole(uid: uid!, completion: { [weak self] role in
                if role.rawValue == 0 {
                    self!.createNewsItemButton.removeFromSuperview()
                    self!.surveyButton.setViewConstraints(top: self!.view.safeAreaLayoutGuide.topAnchor, left: self!.view.safeAreaLayoutGuide.leftAnchor , right: self!.view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10, height: 75)
                }
            })
        }
        
        surveyButton.setViewConstraints(top: createNewsItemButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor , right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10, height: 75)
        
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
}
