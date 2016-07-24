//
//  SmartTestCell.swift
//  SmartTableView
//
//  Created by matrixs on 16/7/24.
//  Copyright © 2016年 matrixs. All rights reserved.
//

import UIKit
import SnapKit

class SmartTestCell: UITableViewCell {
    
    let contentLabel = UILabel()
    let smartImageView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        smartImageView.image = UIImage(named: "test")
        contentView.addSubview(smartImageView)
        smartImageView.contentMode = .Top
        smartImageView.snp_makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(10)
            make.width.equalTo(70)
            make.bottom.equalTo(-20).priority(100)
        }
        contentLabel.textColor = UIColor.blueColor()
        contentLabel.font = UIFont.systemFontOfSize(20)
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(smartImageView.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(-60).priority(100)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fillData(data: NSObject) {
        contentLabel.text = (data as! Dictionary)["txt"]
    }
}
