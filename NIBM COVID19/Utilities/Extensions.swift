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

//extension UIStackView {
//    func createStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat, subViews: [UIView]) -> UIStackView {
//        let stackView = UIStackView(arrangedSubviews: subViews)
//        stackView.distribution = distribution
//        stackView.axis = axis
//        stackView.spacing = spacing
//        return stackView
//    }
//
//    func setStackViewConstraints(
//        top: NSLayoutYAxisAnchor? = nil,
//        bottom: NSLayoutYAxisAnchor? = nil,
//        left: NSLayoutXAxisAnchor? = nil,
//        right: NSLayoutXAxisAnchor? = nil,
//        marginTop: CGFloat = 0,
//        marginBottom: CGFloat = 0,
//        marginLeft: CGFloat = 0,
//        margineRight: CGFloat = 0,
//        width: CGFloat? = nil,
//        height: CGFloat? = nil) {
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//        if let top = top {
//            topAnchor.constraint(equalTo: top, constant: marginTop).isActive = true
//        }
//        if let bottom = bottom {
//            bottomAnchor.constraint(equalTo: bottom, constant: -marginBottom).isActive = true
//        }
//        if let left = left {
//            leftAnchor.constraint(equalTo: left, constant: marginLeft).isActive = true
//        }
//        if let right = right {
//            rightAnchor.constraint(equalTo: right, constant: -margineRight).isActive = true
//        }
//        if let width = width {
//            widthAnchor.constraint(equalToConstant: width).isActive = true
//        }
//        if let height = height {
//            heightAnchor.constraint(equalToConstant: height).isActive = true
//        }
//    }
//}
