//
//  HomeViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var universityCaseUpdatelabel: UILabel = {
        let label = UILabel()
        label.text = "University case update"
        label.font = label.font.withSize(20)
        return label
    }()
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("See More", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(viewMap), for: .touchUpInside)
        return button
    }()
    
    private lazy var stayHomelabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "All you need is\n",  attributes: [.foregroundColor: UIColor.black])
        var secondString = NSMutableAttributedString(string: "stay at home", attributes: [
            .foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)
        ])
        
        firstString.append(secondString)
        let label = UILabel()
        label.attributedText = firstString
        label.numberOfLines = 0
        return label
    }()
    
    private let satusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Constants.greenUserImage)
        return imageView
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "No risk of infection in this area"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(satusImageView)
        view.addSubview(statusLabel)
        return view
    }()
    
    private lazy var safeActionsButton: UIButton = {
        let button = UIButton()
        var firstString = NSMutableAttributedString(string: "Safe Actions ",  attributes: [.foregroundColor: UIColor.black])
        var secondString = NSMutableAttributedString(string: "›", attributes: [
            .foregroundColor: UIColor.black, .font : UIFont.boldSystemFont(ofSize: 20)
        ])
        firstString.append(secondString)
        button.setAttributedTitle(firstString, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        return button
    }()
    
    private lazy var notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var notificationMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Some news about the COVID 19 Pandemic. This is an opportunity to get together and help each other rather than fight like some shitheads. La la lalalalalalalala hurhaurjwsejiasufioudasjfiosdfiosdfniodsfndsoifndsoifnsdfijndsfjkdsnfjkdsnfjkdsnfdjkn"
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var viewNotificationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("›", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 50)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(viewNotifications), for: .touchUpInside)
        return button
    }()
    
    @objc func viewNotifications() {
        let notificationViewController = NotificationViewController()
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @objc func handleSignOut()  {
        let authenticatedUser = Auth.auth()
        do {
            try authenticatedUser.signOut()
            let launchViewController = LaunchViewController()
            launchViewController.modalPresentationStyle = .fullScreen
            self.present(launchViewController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    @objc func viewMap() {
        let mapViewController = MapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func setupHealthSummary() {
        
        let notInfectedSummaryView = UIView().summaryView(imageName: Constants.greenUserImage, count: 10, type: "Not Infected")
        //view.addSubview(notInfectedSummaryView)
        //notInfectedSummaryView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, marginTop: 100, marginLeft: 0, width: view.frame.size.width/3, height: 150)
        
        let highRiskSummaryView = UIView().summaryView(imageName: Constants.redUserImage, count: 0, type: "High Risk")
        //view.addSubview(highRiskSummaryView)
        //highRiskSummaryView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: notInfectedSummaryView.rightAnchor, marginTop: 100, marginLeft: 0, width: view.frame.size.width/3, height: 150)
        
        let lowRiskSummaryView = UIView().summaryView(imageName: Constants.yellowUserImage, count: 1, type: "Low Risk")
        //view.addSubview(lowRiskSummaryView)
        //lowRiskSummaryView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: highRiskSummaryView.rightAnchor, marginTop: 100, marginLeft: 0, width: view.frame.size.width/3, height: 150)
        
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let summaryTitleStackView = UIStackView(arrangedSubviews: [universityCaseUpdatelabel, seeMoreButton])
        summaryTitleStackView.axis = .horizontal
        summaryTitleStackView.distribution = .fill
        
        let summaryDataStackView = UIStackView(arrangedSubviews: [notInfectedSummaryView, highRiskSummaryView, lowRiskSummaryView])
        summaryDataStackView.axis = .horizontal
        summaryDataStackView.distribution = .fillEqually
        //        summaryDataStackView.insertSubview(backgroundView, at: 0)
        //        view.addSubview(summaryDataStackView)
        
        let healthSummaryStackView = UIStackView(arrangedSubviews: [summaryTitleStackView, summaryDataStackView, statusView])
        healthSummaryStackView.axis = .vertical
        healthSummaryStackView.insertSubview(backgroundView, at: 0)
        view.addSubview(healthSummaryStackView)
        
         statusLabel.setViewConstraints(top: summaryDataStackView.bottomAnchor, left: healthSummaryStackView.rightAnchor, marginTop: 100, marginLeft: 0, width: view.frame.size.width/3, height: 150)
         satusImageView.setViewConstraints(top: statusLabel.bottomAnchor, left: healthSummaryStackView.rightAnchor, marginTop: 100, marginLeft: 0, width: view.frame.size.width/3, height: 150)
        
        backgroundView.setViewConstraints(top: healthSummaryStackView.topAnchor, bottom: healthSummaryStackView.bottomAnchor, left: healthSummaryStackView.leftAnchor, right: healthSummaryStackView.rightAnchor, marginTop: 0, marginBottom: 0, marginLeft: 0, marginRight: 0, width: healthSummaryStackView.frame.size.width, height: healthSummaryStackView.frame.size.width)
        healthSummaryStackView.setViewConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 0, marginBottom: 0, width: view.frame.size.width, height: 300)
    }
    
    func setupSafetyActions() {
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let safetyActionsStackView = UIStackView(arrangedSubviews: [stayHomelabel, safeActionsButton])
        safetyActionsStackView.axis = .vertical
        safetyActionsStackView.distribution = .fillProportionally
        safetyActionsStackView.spacing = 0
        
        let safetyActionsLogoStackView = UIStackView(arrangedSubviews: [logoImageView, safetyActionsStackView])
        safetyActionsLogoStackView.axis = .horizontal
        safetyActionsLogoStackView.distribution = .fillEqually
        safetyActionsLogoStackView.spacing = 20
        safetyActionsLogoStackView.insertSubview(backgroundView, at: 0)
        
        view.addSubview(safetyActionsLogoStackView)
        backgroundView.setViewConstraints(top: safetyActionsLogoStackView.topAnchor, bottom: safetyActionsLogoStackView.bottomAnchor, left: safetyActionsLogoStackView.leftAnchor, right: safetyActionsLogoStackView.rightAnchor, marginTop: 0, marginBottom: 0, marginLeft: 0, marginRight: 0, width: safetyActionsLogoStackView.frame.size.width, height: safetyActionsLogoStackView.frame.size.width)
        safetyActionsLogoStackView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 0, marginBottom: 10, marginLeft: 10, marginRight: -10, width: view.frame.size.width, height: 200)
    }
    
    func setupUserInterface() {
        
        //        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        setupSafetyActions()
        setupHealthSummary()
        
       
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        //        imageView.layer.cornerRadius = 10
        //        imageView.clipsToBounds = true
        //        imageView.center = view.center
        //        imageView.image = UIImage(named: Constants.greenUserImage)
        //        view.addSubview(imageView)
        
        //                safetyActionsLogoStackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        //
        //                safetyActionsLogoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
        //                                                                constant: 20).isActive = true
        //                safetyActionsLogoStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
        //                                                                  constant: -20).isActive = true
        //                safetyActionsLogoStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
        //                                                                 constant: 20).isActive = true
        //
        //        notificationView.translatesAutoresizingMaskIntoConstraints = false
        //        notificationMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        //        viewNotificationsButton.translatesAutoresizingMaskIntoConstraints = false
        //
        //        notificationView.addSubview(notificationMessageLabel)
        //        notificationView.addSubview(viewNotificationsButton)
        //        view.addSubview(notificationView)
        //
        //        notificationView.topAnchor.constraint(equalTo: safetyActionsLogoStackView.bottomAnchor,
        //                                              constant: 10).isActive = true
        //        notificationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        //        notificationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        //        notificationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //
        //        notificationMessageLabel.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 5).isActive = true
        //        notificationMessageLabel.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0).isActive = true
        //        notificationMessageLabel.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 0).isActive = true
        //        notificationMessageLabel.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: -30).isActive = true
        //
        //        viewNotificationsButton.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: -5).isActive = true
        //        viewNotificationsButton.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0).isActive = true
        //        viewNotificationsButton.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 0).isActive = true
        //        viewNotificationsButton.leftAnchor.constraint(equalTo: notificationMessageLabel.rightAnchor, constant: 5).isActive = true
        
        
        //        summaryImageStackView.setStackViewConstraints(
        //            top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor,
        //            marginTop: 0, marginBottom: 0, marginLeft: 0, margineRight: 0, width: view.frame.size.width, height: 100)
        //        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        //        view.addSubview(seeMoreButton)
        //        seeMoreButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        seeMoreButton.topAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 5).isActive = true
        //        seeMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        //        seeMoreButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        //        let summaryTypeLabelStackView = UIStackView(arrangedSubviews: [notInfectedlabel, lowRisklabel, highRisklabel])
        //        summaryTypeLabelStackView.axis = .horizontal
        //        summaryTypeLabelStackView.distribution = .fillEqually
        //
        //        let summaryCountLabelStackView = UIStackView(arrangedSubviews: [notInfectedCountLabel, lowRiskCountLabel, highRiskCountLabel])
        //        summaryCountLabelStackView.axis = .horizontal
        //        summaryCountLabelStackView.distribution = .fillEqually
        //
        //        let summaryItemsStackView = UIStackView(arrangedSubviews: [seeMoreButton, summaryTypeLabelStackView, summaryCountLabelStackView])
        //        summaryItemsStackView.axis = .vertical
        //        summaryItemsStackView.distribution = .fillProportionally
        //
        //        view.addSubview(summaryItemsStackView)
        //        summaryItemsStackView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        summaryItemsStackView.topAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 15).isActive = true
        //        summaryItemsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        //        summaryItemsStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        summaryItemsStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        //        view.addSubview(signOutButton)
        //        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        //        signOutButton.topAnchor.constraint(equalTo: safetyActionsStackView.bottomAnchor, constant: 20).isActive = true
        //        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
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
