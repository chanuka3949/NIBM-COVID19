//
//  SurveyResultsViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/20/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase

class SurveyResultsViewController: UIViewController {
    
    struct Result {
        var user: String?,
        one: Bool?,
        two: Bool?,
        three: Bool?,
        four: Bool?,
        five: Bool?,
        modifiedDate: TimeInterval?
    }
    
    private var surveyResults: [Result] = []
    private var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchSurveyResults()
        
    }
    
    private var surveyResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SurveyResultCell.self, forCellReuseIdentifier: SurveyResultCell.identifier)
        return tableView
    }()
    
    func fetchSurveyResults() {
        databaseRef.child(Constants.userHealth).child(Constants.surveyResults).observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            let value = snapshot.value as? NSDictionary
            var result = Result()
            result.user = value?["user"] as? String
            result.one = value?["questionOne"] as? Bool
            result.two = value?["questionTwo"] as? Bool
            result.three = value?["questionThree"] as? Bool
            result.four = value?["questionFour"] as? Bool
            result.five = value?["questionFive"] as? Bool
            result.modifiedDate = value?["modifiedDate"] as? TimeInterval
            self?.surveyResults.append(result)
            self?.surveyResultsTableView.insertRows(at: [IndexPath(row: (self?.surveyResults.count)!-1, section: 0)], with: UITableView.RowAnimation.automatic)
        }) { (error) in
            print("Error Occurred: \(error)")
        }
    }
    
    func setupTableView()  {
        surveyResultsTableView.delegate = self
        surveyResultsTableView.dataSource = self
        surveyResultsTableView.separatorInset = .zero
        surveyResultsTableView.frame = view.bounds
        surveyResultsTableView.separatorStyle = .none
        view.addSubview(surveyResultsTableView)
    }
}

extension SurveyResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        surveyResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = surveyResultsTableView.dequeueReusableCell(withIdentifier: SurveyResultCell.identifier, for: indexPath) as! SurveyResultCell
        cell.user.text = "User: \(surveyResults[indexPath.row].user ?? "")"
        cell.userId.text = "User Id: \(surveyResults[indexPath.row].user ?? "")"
        cell.answerOne.text = "Question One: \(surveyResults[indexPath.row].one ?? false ? "True" : "False")"
        cell.answerTwo.text = "Question Two: \(surveyResults[indexPath.row].two ?? false ? "True" : "False")"
        cell.answerThree.text = "Question Three: \(surveyResults[indexPath.row].three ?? false ? "True" : "False")"
        cell.answerFour.text = "Question Four: \(surveyResults[indexPath.row].four ?? false ? "True" : "False")"
        cell.answerFive.text = "Question Five: \(surveyResults[indexPath.row].five ?? false ? "True" : "False")"
        let formattedDate: DateFormatter = {
            let date = DateFormatter()
            date.timeStyle = .none
            date.dateStyle = .short
            return date
        }()
        cell.modifiedDate.text = "Date: \(formattedDate.string(from: Date(timeIntervalSince1970: surveyResults[indexPath.row].modifiedDate!)))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
}
