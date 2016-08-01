//
//  UITableViewCell+SmartTableViewCell.swift
//  SmartTableView
//
//  Created by matrixs on 16/7/24.
//  Copyright © 2016年 matrixs. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public func fillData(data: NSObject) {
        NSException(name: "SmartTableViewException", reason: "You must implement your fillData methods in you custom UITableViewCell class", userInfo: nil).raise()
    }
}

