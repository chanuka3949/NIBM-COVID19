//
//  NotificationViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase

class NotificationViewController: UIViewController {
    
    private var newsUpdates: [String] = []
    
    private var newsUpdatesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsItemCell.self, forCellReuseIdentifier: "NewsItemCell")
        return tableView
    }()
    
    
    func fetchNewsUpdates() {
        Database.database().reference().child(Constants.newsUpdates).observe(.childAdded, with: { (snapshot) -> Void in
            let value = snapshot.childSnapshot(forPath: "news").value
            let comment: String = value as! String
            self.newsUpdates.append(comment)
            self.newsUpdatesTableView.insertRows(at: [IndexPath(row: self.newsUpdates.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
        }) { (error) in
            print("Error Occurred: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView();
        fetchNewsUpdates();
    }
    func setupTableView()  {
        newsUpdatesTableView.delegate = self
        newsUpdatesTableView.dataSource = self
        newsUpdatesTableView.separatorInset = UIEdgeInsets.zero
        newsUpdatesTableView.frame = view.bounds
        view.addSubview(newsUpdatesTableView)
    }
}
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                newsUpdates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsUpdatesTableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
        cell.newsItemLabel.text = newsUpdates[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
