//
//  SurveyViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class SurveyViewController: UIViewController {
    
    private var questionNo = 1
    private let uid = Auth.auth().currentUser?.uid
    private let spinner = UIActivityIndicatorView(style: .large)
    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    private var resultList = [SurveyResult]()
    private var result = SurveyResult(context: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext)
    private var user = User(context: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext)
    
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yes", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.some(UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)), for: .highlighted)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var noButton: UIButton = {
        let button = UIButton()
        button.setTitle("No", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.some(UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)), for: .highlighted)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yesButton, noButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    
    // MARK: - Question One
    
    private lazy var q1TitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Question One"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        return label
    }()
    private lazy var q1BodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\t\tCough\n\t\tSHORTNESS OF BREATH\n\t\tSORE THROAT\n\t\tHEADACHE"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = .black
        return label
    }()
    private lazy var q1Label: UILabel = {
        let label = UILabel()
        label.text = "Are you having any of the above symptoms?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var q1StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [q1TitleLabel, q1BodyLabel, q1Label, buttonStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Question Two
    
    private lazy var q2TitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Question Two"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        return label
    }()
    private lazy var q2BodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\t\tAVOID CONTACT WITH\n\t\tSICK PEOPLE"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = .black
        return label
    }()
    private lazy var q2Label: UILabel = {
        let label = UILabel()
        label.text = "Have you been in contact with sick people?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var q2StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [q2TitleLabel, q2BodyLabel, q2Label, buttonStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Question Three
    
    private lazy var q3TitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Question Three"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        return label
    }()
    private lazy var q3BodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\t\tAVOID CROWDED\n\t\tPLACES"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = .black
        return label
    }()
    private lazy var q3Label: UILabel = {
        let label = UILabel()
        label.text = "Have you been exposed to crowded places?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var q3StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [q3TitleLabel, q3BodyLabel, q3Label, buttonStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Question Fpur
    
    private lazy var q4TitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Question Four"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        return label
    }()
    private lazy var q4BodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\t\tCONTINUOUS COUGH\n\t\tLOSS OR CHANGE OF SMELL AND TASTE"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = .black
        return label
    }()
    private lazy var q4Label: UILabel = {
        let label = UILabel()
        label.text = "Are you having any of the above symptoms?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var q4StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [q4TitleLabel, q4BodyLabel, q4Label, buttonStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Question Five
    
    private lazy var q5TitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Question Five"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        return label
    }()
    private lazy var q5BodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = .black
        return label
    }()
    private lazy var q5Label: UILabel = {
        let label = UILabel()
        label.text = "Have you had a fever during the past couple of days?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var q5StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [q5TitleLabel, q5BodyLabel, q5Label, buttonStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        presentQuestion(questionNo: questionNo)
    }
    
    @objc func noButtonClicked() {
        
        switch questionNo {
        case 1:
            result.question1 = false
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 2:
            result.question2 = false
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 3:
            result.question3 = false
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 4:
            result.question4 = false
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 5:
            result.question5 = false
            saveSurveyData()
        default:
            return
        }
    }
    
    @objc func yesButtonClicked() {
        switch questionNo {
        case 1:
            result.question1 = true
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 2:
            result.question2 = true
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 3:
            result.question3 = true
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 4:
            result.question4 = true
            questionNo += 1
            presentQuestion(questionNo: questionNo)
        case 5:
            result.question5 = true
            saveSurveyData()
        default:
            return
        }
    }
    
    func saveSurveyData() {
        var riskLevel = 0
        result.uid = uid
        result.modifiedDate = Date()
        riskLevel += result.question1 ? 1 : 0
        riskLevel += result.question2 ? 1 : 0
        riskLevel += result.question3 ? 1 : 0
        riskLevel += result.question4 ? 1 : 0
        riskLevel += result.question5 ? 1 : 0
        result.riskLevel = Int16(riskLevel)
        user.uid = uid
        user.riskLevel = calculateNewRiskLevelBySurvey(newRiskLevel: Int16(riskLevel))
        user.modifiedDate = Date()
        resultList.append(result)
        
        do {
            spinner.startAnimating()
            try context.save()
            let values = ["userId": uid!,
                          "questionOne": result.question1,
                          "questionTwo": result.question2,
                          "questionThree": result.question3,
                          "questionFour": result.question4,
                          "questioFive": result.question5,
                          "riskLevel": user.riskLevel,
                          "modifiedDate": result.modifiedDate?.timeIntervalSince1970 as Any] as [String : Any]
            Database.database().reference().child(Constants.userHealth).child(Constants.surveyResults).child(uid!).updateChildValues(values) { (error, ref) in
                if error != nil {
                    let alert = UIAlertController(title: "An error occurred", message: "Couldn't save survey data on database", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                Database.database().reference().child(Constants.userHealth).child(Constants.surveySummary).child(self.uid!).updateChildValues(["riskLevel":self.user.riskLevel]) { (error, ref) in
                    if error != nil {
                        let alert = UIAlertController(title: "An error occurred", message: "Couldn't save survey summary on database", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    self.spinner.stopAnimating()
                    let alert = UIAlertController(title: "Success", message: "Survey results saved successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)}
                    ))
                    self.present(alert, animated: true)
                }
            }
        } catch {
            spinner.stopAnimating()
            let alert = UIAlertController(title: "An error occurred", message: "Couldn't save survey data on database", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func fetchLastReading(uid: String) -> Int16 {
        let filterPredicate = NSPredicate(format: "uid == %@"
            , uid)
        var riskLevel: Int16 = 0
        let sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        let request: NSFetchRequest<SurveyResult> = SurveyResult.fetchRequest()
        request.predicate = filterPredicate
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1
        do {
            resultList = try context.fetch(request)
            if resultList.count != 0 {
                riskLevel = resultList[0].riskLevel
            }
        } catch {
            print("DEBUG: Error fecthing data from context \(error)")
        }
        return riskLevel
    }
    
    func calculateNewRiskLevelBySurvey(newRiskLevel: Int16) -> Int16 {
        let prevRiskLevel = fetchLastReading(uid: uid!)
        let value = (newRiskLevel + prevRiskLevel) / 2
        return value
    }
    
    func presentQuestion(questionNo: Int) {
        switch questionNo {
        case 1:
            view.addSubview(q1StackView)
            
            q1StackView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginBottom: 20, marginLeft: 20, marginRight: 20)
        case 2:
            q1StackView.removeFromSuperview()
            view.addSubview(q2StackView)
            
            q2StackView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginBottom: 20, marginLeft: 20, marginRight: 20)
        case 3:
            q2StackView.removeFromSuperview()
            view.addSubview(q3StackView)
            
            q3StackView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginBottom: 20, marginLeft: 20, marginRight: 20)
        case 4:
            q3StackView.removeFromSuperview()
            view.addSubview(q4StackView)
            
            q4StackView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginBottom: 20, marginLeft: 20, marginRight: 20)
        case 5:
            q4StackView.removeFromSuperview()
            view.addSubview(q5StackView)
            
            q5StackView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 20, marginBottom: 20, marginLeft: 20, marginRight: 20)
        default:
            return
        }
    }
    
    
    func setupUserInterface() {
        //navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(buttonStackView)
        buttonStackView.setViewConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10, height: 40)
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
