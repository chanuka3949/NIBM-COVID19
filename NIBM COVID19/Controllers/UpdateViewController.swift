//
//  UpdateViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello From Update"
        return label
    }()
    
    private lazy var surveyButton: UIButton = {
           let button = UIButton()
           button.setTitle("Survey", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.setTitleColor(.black, for: .highlighted)
           button.layer.cornerRadius = 5
           button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
           button.addTarget(self, action: #selector(takeSurvey), for: .touchUpInside)
           return button
       }()
    
    @objc func takeSurvey() {
        let surveyViewController = SurveyViewController()
        navigationController?.pushViewController(surveyViewController, animated: true)
    }
    
    private lazy var showNewsButton: UIButton = {
            let button = UIButton()
            button.setTitle("Survey", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.black, for: .highlighted)
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
            button.addTarget(self, action: #selector(showNews), for: .touchUpInside)
            return button
        }()
     
     @objc func showNews() {
         let surveyViewController = SurveyViewController()
         navigationController?.pushViewController(surveyViewController, animated: true)
     }
    
    private lazy var updateTemperatureButton: UIButton = {
            let button = UIButton()
            button.setTitle("Survey", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.black, for: .highlighted)
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
            button.addTarget(self, action: #selector(updateTemperature), for: .touchUpInside)
            return button
        }()
     
     @objc func updateTemperature() {
         let surveyViewController = SurveyViewController()
         navigationController?.pushViewController(surveyViewController, animated: true)
     }
    
    private lazy var temperatureTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Temperature"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        surveyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(surveyButton)
        surveyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        surveyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
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
