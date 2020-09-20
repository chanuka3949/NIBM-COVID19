//
//  SurveyResultCell.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/20/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import Foundation
import UIKit

class SurveyResultCell: UITableViewCell {
    static let identifier = "SurveyResultCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var user: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var userId: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var answerOne: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var answerTwo: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var answerThree: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var answerFour: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var answerFive: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var modifiedDate: UILabel = {
           let label = UILabel()
           return label
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(user)
        contentView.addSubview(userId)
        contentView.addSubview(answerOne)
        contentView.addSubview(answerTwo)
        contentView.addSubview(answerThree)
        contentView.addSubview(answerFour)
        contentView.addSubview(answerFive)
        contentView.addSubview(modifiedDate)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSubviews()
        user.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
        userId.frame = CGRect(x: 10, y: 20, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
        answerOne.frame = CGRect(x: 10, y: 40, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
        answerTwo.frame = CGRect(x: 10, y: 60, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
        answerThree.frame = CGRect(x: 10, y: 80, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
        answerFour.frame = CGRect(x: 10, y: 100, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
        answerFive.frame = CGRect(x: 10, y: 120, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
        modifiedDate.frame = CGRect(x: 10, y: 140, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
    }
    
}
