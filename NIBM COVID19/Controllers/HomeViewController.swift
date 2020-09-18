//
//  HomeViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var locationManager = LocationHandler.sharedInstance.locationManager
    private let uid = Auth.auth().currentUser?.uid
    
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
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "Logo")
        return imageView
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
    
    let notInfectedSummaryView = UIView().summaryView(imageName: Constants.greenUserImage, count: 0, type: "Not Infected")
    
    let highRiskSummaryView = UIView().summaryView(imageName: Constants.redUserImage, count: 0, type: "High Risk")
    
    let lowRiskSummaryView = UIView().summaryView(imageName: Constants.yellowUserImage, count: 0, type: "Low Risk")
    
    //    private let statusLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = "No risk of infection in this area"
    //        label.textAlignment = .center
    //        return label
    //    }()
    
    //    private let statusView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .orange
    //        view.layer.cornerRadius = 5
    //        return view
    //    }()
    
    //    private lazy var signOutButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("Sign Out", for: .normal)
    //        button.setTitleColor(.black, for: .normal)
    //        button.layer.cornerRadius = 5
    //        button.layer.borderWidth = 0.5
    //        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
    //        return button
    //    }()
    let newsUpdateMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Some news about the COVID 19 Pandemic. This is an opportunity to get together and help each other rather than fight like some shitheads. La la lalalalalalalala hurhaurjwsejiasufioudasjfiosdfiosdfniodsfndsoifndsoifnsdfijndsfjkdsnfjkdsnfjkdsnfdjknSome news about the COVID 19 Pandemic. This is an opportunity to get together and help each other rather than fight like some shitheads. La la lalalalalalalala hurhaurjwsejiasufioudasjfiosdfiosdfniodsfndsoifndsoifnsdfijndsfjkdsnfjkdsnfjkdsnfdjkn"
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var latestNewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Latest News Updates"
        return label
    }()
    
    private lazy var viewNotificationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("View News Updates", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
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
    
    @objc func viewMap() {
        let mapViewController = MapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func getStats() {
        var low = 0
        var medium = 0
        var high = 0
        var riskLevel = 0
        
        let notInfected: UILabel = notInfectedSummaryView.subviews[1] as! UILabel
        let highRisk: UILabel = highRiskSummaryView.subviews[1] as! UILabel
        let lowRisk: UILabel = lowRiskSummaryView.subviews[1] as! UILabel
        
        Database.database().reference().child(Constants.userHealth).child(Constants.surveySummary).observe(.value) { snapshot in
            low = 0
            medium = 0
            high = 0
            for child in snapshot.children{
                
                let value:DataSnapshot = child as! DataSnapshot
                riskLevel = value.childSnapshot(forPath: "riskLevel").value as? Int ?? 0
                
                switch riskLevel {
                case 5:
                    high+=1
                case 4:
                    high+=1
                case 3:
                    medium+=1
                case 2:
                    medium+=1
                case 1:
                    low+=1
                case 0:
                    low+=1
                default: break
                }
                
            }
            notInfected.text = String(low)
            highRisk.text = String(high)
            lowRisk.text = String(medium)
        }
        var news = ""
        Database.database().reference().child(Constants.newsUpdates).queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) -> Void in
            let newsVal = "\(snapshot.childSnapshot(forPath: "news").value!) \n\n"
            news.append(contentsOf: newsVal)
            self.newsUpdateMessageLabel.text = news
            //            if snapshot.childrenCount == 0 {
            //                self.newsUpdateMessageLabel.text = "No News Updates"
            //                self.newsUpdateMessageLabel.textAlignment = .center
            //                return
            //            }
            //            news = ""
            //
            //            for child in snapshot.children{
            //                let value:DataSnapshot = child as! DataSnapshot
            //                let newsVal = "\(value.childSnapshot(forPath: "news").value as! String) \n\n"
            //                news.append(contentsOf: newsVal)
            //            }
            //            self.newsUpdateMessageLabel.text = news
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        getStats()
        LocationHandler.sharedInstance.updateUserLocation(uid: uid!)
    }
    
    
    func setupUserInterface() {
        navigationController?.navigationBar.topItem?.title = "Summary"
        view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        
        let safetyActionView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 10
            view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            return view
        }()
        view.addSubview(logoImageView)
        
        logoImageView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, marginTop: 5, marginBottom: 5, marginLeft: 5, marginRight: 5, width: view.frame.size.width / 2, height: 150)
        
        view.addSubview(safetyActionView)
        safetyActionView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: logoImageView.rightAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 5, marginBottom: 5, marginLeft: 5, marginRight: 5, height: 150)
        
        safetyActionView.addSubview(stayHomelabel)
        safetyActionView.addSubview(safeActionsButton)
        
        stayHomelabel.setViewConstraints(top: safetyActionView.topAnchor, left: safetyActionView.leftAnchor, right: safetyActionView.rightAnchor, marginTop: 30, marginBottom: 5, marginLeft: 5, marginRight: 5)
        safeActionsButton.setViewConstraints(top: stayHomelabel.bottomAnchor, left: safetyActionView.leftAnchor, right: safetyActionView.rightAnchor, marginTop: 5, marginBottom: 5, marginLeft: 5, marginRight: 5)
        
        
        
        let summaryView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        view.addSubview(summaryView)
        summaryView.setViewConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 5, marginBottom: 5, marginLeft: 5, marginRight: 5, height: 200)
        
        summaryView.addSubview(universityCaseUpdatelabel)
        summaryView.addSubview(seeMoreButton)
        
        universityCaseUpdatelabel.setViewConstraints(top: summaryView.topAnchor, left: summaryView.leftAnchor,marginTop: 10, marginLeft: 5, marginRight: 5)
        seeMoreButton.setViewConstraints(top: summaryView.topAnchor, right: summaryView.rightAnchor, marginTop: 5, marginLeft: 5, marginRight: 5)
        
        let summaryDataStackView = UIStackView(arrangedSubviews: [notInfectedSummaryView, highRiskSummaryView, lowRiskSummaryView])
        summaryDataStackView.axis = .horizontal
        summaryDataStackView.distribution = .fillEqually
        
        summaryView.addSubview(summaryDataStackView)
        
        summaryDataStackView.setViewConstraints(top:seeMoreButton.bottomAnchor ,bottom: summaryView.bottomAnchor, left: summaryView.leftAnchor, right: summaryView.rightAnchor, marginTop: 20, marginBottom: 5, marginLeft: 5, marginRight: 5)
        
        
        
        let newsUpdatesView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 10
            view.backgroundColor = .white
            return view
        }()
        
        //        let separatorView = UIView()
        //        separatorView.backgroundColor = .lightGray
        //        view.addSubview(separatorView)
        //        separatorView.setViewConstraints(bottom: newsUpdatesView.bottomAnchor, left: newsUpdatesView.leftAnchor, right: newsUpdatesView.rightAnchor, marginLeft: 8, height: 0.75)
        
        
        
        view.addSubview(newsUpdatesView)
        newsUpdatesView.setViewConstraints(top: safetyActionView.bottomAnchor, bottom: summaryView.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10)
        
        newsUpdatesView.addSubview(viewNotificationsButton)
        newsUpdatesView.addSubview(newsUpdateMessageLabel)
        
        viewNotificationsButton.setViewConstraints(top: newsUpdatesView.topAnchor, right: newsUpdatesView.rightAnchor, marginTop: 5, marginBottom: 5, marginLeft: 5, marginRight: 5)
        
        newsUpdateMessageLabel.setViewConstraints(top: newsUpdatesView.topAnchor, bottom: newsUpdatesView.bottomAnchor, left: newsUpdatesView.leftAnchor, right: newsUpdatesView.rightAnchor, marginTop: 40, marginBottom: 10, marginLeft: 10, marginRight: 10)
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
