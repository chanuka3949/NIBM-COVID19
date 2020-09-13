//
//  NewsItemCell.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/13/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

class NewsItemCell: UITableViewCell {
    
    static let identifier = "NewsItemCell"
    
    lazy var newsItemLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsItemLabel)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSubviews()
        newsItemLabel.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
