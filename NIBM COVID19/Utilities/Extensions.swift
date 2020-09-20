//
//  Extensions.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/28/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

extension UIView {
    
    func setViewConstraints(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        marginTop: CGFloat = 0,
        marginBottom: CGFloat = 0,
        marginLeft: CGFloat = 0,
        marginRight: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: marginTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -marginBottom).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: marginLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -marginRight).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    func summaryView(imageName: String, count: Int, type: String) -> UIView {
        
        let view:UIView = UIView()
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageName)
        view.addSubview(imageView)
        imageView.setViewConstraints(width: 40,height: 40)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        let countLabel = UILabel()
        countLabel.font = countLabel.font.withSize(40)
        countLabel.text = String(count)
        countLabel.textAlignment = .center
        view.addSubview(countLabel)
        countLabel.setViewConstraints(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, marginTop: 10)
        countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let typeLabel = UILabel()
        typeLabel.font = typeLabel.font.withSize(14)
        typeLabel.text = type
        typeLabel.textColor = .gray
        typeLabel.textAlignment = .center
        view.addSubview(typeLabel)
        typeLabel.setViewConstraints(top: countLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, marginTop: 10)
        typeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        return view
    }
}

extension UIViewController {
    
    func presentAlert(title: String, message: String, actionTitle: String, currentVC: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        currentVC.present(alert, animated: true)
    }
    
    func validateEmail(email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateTemperature(temp: String) -> Bool {
        let pattern = "\\d{1,3}\\.?(\\d{1,2})?"
        let tempPredicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return tempPredicate.evaluate(with: temp)
    }
}

