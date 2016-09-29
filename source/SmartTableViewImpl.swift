//
//  SmartTableViewImpl.swift
//  SmartTableView
//
//  Created by matrixs on 16/7/24.
//  Copyright © 2016年 matrixs. All rights reserved.
//

import UIKit

class SmartTableViewImpl: NSObject, UITableViewDataSource, UITableViewDelegate {
    var section: NSInteger = 0
    var data: [NSObject]?
    var forward: AnyObject?
    var cellClass: AnyClass?
    var heightArray = [CGFloat]()
    weak var tableView: UITableView?
    var cell: UITableViewCell?
    var constraintsCached = false
    var cellIdentifier: String?
    
    private struct Identifiers {
        static let defaultIdentifier = "SmartCell"
        static var BottomKey = "BottomKey"
        static var BottomMarginKey = "BottomMarginKey"
    }
    
    func bindDataSource(dataSource: [NSObject], delegate: AnyObject) {
        tableView?.dataSource = self
        tableView?.delegate = self
        forward = delegate
        data = dataSource
    }
    
    func registerClass(cellClass: AnyClass, dataSource: [NSObject], delegate: AnyObject) {
        if cellIdentifier == nil {
            cellIdentifier = Identifiers.defaultIdentifier
        }
        bindDataSource(dataSource: dataSource, delegate: delegate)
        tableView?.register(cellClass, forCellReuseIdentifier: cellIdentifier!)
        self.cellClass = cellClass
    }
    
    func registerClass(cellClass: AnyClass, dataSource: [NSObject], delegate: AnyObject, identifier: String) {
        self.cellIdentifier = identifier
        registerClass(cellClass: cellClass, dataSource: dataSource, delegate: delegate)
    }
    
    func registerNib(nib: UINib, dataSource: [NSObject], delegate: AnyObject) {
        if cellIdentifier == nil {
            cellIdentifier = Identifiers.defaultIdentifier
        }
        bindDataSource(dataSource: dataSource, delegate: delegate)
        tableView?.register(nib, forCellReuseIdentifier: cellIdentifier!)
    }
    
    func registerNib(nib: UINib, dataSource: [NSObject], delegate: AnyObject, identifier: String) {
        self.cellIdentifier = identifier
        registerNib(nib: nib, dataSource: dataSource, delegate: delegate)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let forward_ = forward else { return 1 }
        let selector = #selector(UITableViewDataSource.numberOfSections)
        if forward_.responds!(to: selector) {
            return ((forward_.perform(selector).takeUnretainedValue() as? NSNumber)?.intValue)!
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forward_ = forward else { return 0 }
        let selector = #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
        if forward_.responds(to: selector) {
            if let num = forward_.perform(selector, with: tableView, with: section).takeUnretainedValue() as? NSNumber {
               return num.intValue
            } else {
                return 0
            }
        }
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        guard let forward_ = forward else { return UITableViewCell() }
        let selector = #selector(UITableViewDataSource.tableView(_:cellForRowAt:))
        if forward_.responds(to: selector) {
            cell = forward_.perform(selector, with: tableView, with: indexPath).takeUnretainedValue() as? UITableViewCell
            return cell!
        }
        let identifier = identifierForRow(row: indexPath.row)
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        }
        if cell == nil {
            let cellSelector = #selector(SmartTableViewImpl.cellClassForRowAtIndexPath(indexPath:))
            if forward_.responds(to: cellSelector) {
                cell = (forward_.perform(cellSelector, with: indexPath).takeUnretainedValue()) as? UITableViewCell
                let cellClass = (forward_.perform(cellSelector, with: indexPath).takeUnretainedValue()) as? UITableViewCell.Type
                cell = cellClass!.init(style: .default, reuseIdentifier: identifier)
            } else if self.cellClass != nil {
                cell = (self.cellClass as? UITableViewCell.Type)!.init(style: .default, reuseIdentifier: identifier)
            } else {
                cell = (cellClassForRowAtIndexPath(indexPath: indexPath as NSIndexPath) as! UITableViewCell.Type).init(style: .default, reuseIdentifier: identifier)
            }
        }
        cell?.fillData(data: data![indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let forward_ = forward else { return 0 }
        let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
        if forward_.responds(to: selector) {
            return CGFloat((forward_.perform(selector, with: tableView, with: indexPath).takeUnretainedValue() as? NSNumber)!.floatValue)
        }
        if indexPath.row < heightArray.count && heightArray[indexPath.row] > 0 {
            return heightArray[indexPath.row]
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let forward_ = forward {
            let selector = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
            if forward_.responds(to: selector) {
                forward_.perform(selector, with: tableView, with: indexPath)
            }
        }
    }
    
    func identifierForRow(row: Int) -> String {
        if let forward_ = forward {
            let selector = #selector(SmartTableViewImpl.identifierForRow(row:))
            if forward_.responds(to: selector) {
                return (forward_.perform(selector, with: NSNumber(value: row)).takeUnretainedValue() as! String)
            }
        }
        return cellIdentifier!
    }
    
    func cellClassForRowAtIndexPath(indexPath: NSIndexPath) -> AnyClass {
        return UITableViewCell.self
    }
    
    func calculateCellHeight(cell: UITableViewCell, data: NSObject) {
        var customCell = true
        if let forward_ = forward {
            let selector = #selector(UITableViewDataSource.tableView(_:cellForRowAt:))
            if forward_.responds(to: selector) {
                customCell = false
            }
        }
        if customCell {
            cell.fillData(data: data)
        }
        updateLayout(cell: cell)
        let height = maxMarginBottomInSubviews(view: cell.contentView) + 1
        heightArray.append(height)
        constraintsCached = true
    }
    
    func maxMarginBottomInSubviews(view: UIView) -> CGFloat {
        var maxMarginBottom: CGFloat = 0
        if view.subviews.count > 0 {
            for subview in view.subviews {
                var height: CGFloat = 0
                if constraintsCached {
                    let bottomValue = objc_getAssociatedObject(subview, &Identifiers.BottomKey) as? NSNumber
                    if bottomValue != nil {
                        height += CGFloat(bottomValue!.floatValue)
                    }
                    let bottomMarginValue = objc_getAssociatedObject(subview, &Identifiers.BottomMarginKey) as? NSNumber
                    if bottomMarginValue != nil {
                        height += CGFloat(bottomMarginValue!.floatValue)
                    }
                } else {
                    let array = view.constraints
                    for constraint in array {
                        if subview == constraint.firstItem as! NSObject {
                            let firstAttribute = constraint.firstAttribute
                            if firstAttribute == NSLayoutAttribute.bottom {
                                let bottom = fabs(constraint.constant)
                                height += bottom
                                objc_setAssociatedObject(subview, &Identifiers.BottomKey, NSNumber(value: Float(bottom)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                            }
                            if firstAttribute == NSLayoutAttribute.bottomMargin {
                                let bottomMargin = fabs(constraint.constant)
                                height += bottomMargin
                                objc_setAssociatedObject(subview, &Identifiers.BottomMarginKey, NSNumber(value: Float(bottomMargin)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                            }
                        }
                    }
                }
                let array = subview.constraints
                for constraint in array {
                    if subview == constraint.firstItem as! NSObject {
                        let firstAttribute = constraint.firstAttribute
                        if firstAttribute == NSLayoutAttribute.bottom {
                            let bottom = fabs(constraint.constant)
                            height += bottom
                            objc_setAssociatedObject(subview, &Identifiers.BottomKey, NSNumber(value: Float(bottom)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                        }
                        if firstAttribute == NSLayoutAttribute.bottomMargin {
                            let bottomMargin = fabs(constraint.constant)
                            height += bottomMargin
                            objc_setAssociatedObject(subview, &Identifiers.BottomMarginKey, NSNumber(value: Float(bottomMargin)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                        }
                    }
                }
                height = height + subview.frame.origin.y + subview.bounds.size.height
                if height > maxMarginBottom {
                    maxMarginBottom = height
                }
            }
        }
        return maxMarginBottom
    }
    
    func updateLayout(cell: UITableViewCell) {
        tableView?.superview?.layoutIfNeeded()
        cell.contentView.bounds = CGRect(x: 0, y: 0, width: tableView!.bounds.width, height: cell.bounds.height)
        cell.updateConstraints()
        setPreferredMaxWidthOfUILabelForView(view: cell.contentView)
        cell.layoutIfNeeded()
    }
    
    func setPreferredMaxWidthOfUILabelForView(view: UIView) {
        if view.subviews.count > 0 {
            for childView in view.subviews {
                setPreferredMaxWidthOfUILabelForView(view: childView)
            }
        } else {
            if view.isKind(of: UILabel.self) {
                let label = view as! UILabel
                label.superview?.layoutIfNeeded()
                label.preferredMaxLayoutWidth = label.bounds.size.width
            }
        }
    }

    
    func calcCellHeight() {
        if let data_ = data {
            heightArray.removeAll()
            for (index, obj) in data_.enumerated() {
                let identifier = identifierForRow(row: index)
                if cell == nil || self.cellIdentifier == nil || (self.cellIdentifier! != identifier) {
                    cell = tableView?.dequeueReusableCell(withIdentifier: identifierForRow(row: index))
                    constraintsCached = false
                }
                self.cellIdentifier = identifier
                calculateCellHeight(cell: cell!, data: obj)
            }
        }
    }
}
