//
//  UITableViewCell+SmartTableViewCell.swift
//  SmartTableView
//
//  Created by matrixs on 16/7/24.
//  Copyright © 2016年 matrixs. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        if self !== UITableViewCell.self {
            return
        }
        dispatch_once(&Static.token) { 
            let layoutSubviewsSEL = #selector(layoutSubviews)
            let layoutSubviewsMethod = class_getInstanceMethod(self, layoutSubviewsSEL)
            let layoutSubviewsIMP = method_getImplementation(layoutSubviewsMethod)
            
            let smartLayoutSubviewsSEL = #selector(smartLayoutSubviews)
            let smartLayoutSubviewsMethod = class_getInstanceMethod(self, smartLayoutSubviewsSEL)
            let smartLayoutSubviewsIMP = method_getImplementation(smartLayoutSubviewsMethod)
            
            let didAddMethod = class_addMethod(self, layoutSubviewsSEL, smartLayoutSubviewsIMP, method_getTypeEncoding(smartLayoutSubviewsIMP))
            if didAddMethod {
                class_replaceMethod(self, smartLayoutSubviewsSEL, layoutSubviewsIMP, method_getTypeEncoding(layoutSubviewsMethod))
            } else {
                method_exchangeImplementations(layoutSubviewsMethod, smartLayoutSubviewsMethod)
            }
        }
    }
    
    public func fillData(data: NSObject) {
        NSException(name: "SmartTableViewException", reason: "You must implement your fillData methods in you custom UITableViewCell class", userInfo: nil).raise()
    }
    
    func smartLayoutSubviews() {
        smartLayoutSubviews()
        if self.isKindOfClass(UITableViewCell.self) {
//            let constraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: self.bounds.size.width)
//            self.contentView.addConstraint(constraint)
            let type = self.accessoryType
            let view = self.accessoryView
            setPreferredMaxWidthOfUILabelForView(self.contentView)
            self.accessoryType = type
            self.accessoryView = view
//            self.contentView.removeConstraint(constraint)
        }
    }
    
    func setPreferredMaxWidthOfUILabelForView(view: UIView) {
        if view.subviews.count > 0 {
            for childView in view.subviews {
                setPreferredMaxWidthOfUILabelForView(childView)
            }
        } else {
            if view.isKindOfClass(UILabel.self) {
                let label = view as! UILabel
                label.layoutIfNeeded()
                label.preferredMaxLayoutWidth = label.bounds.size.width
            }
        }
    }
}

