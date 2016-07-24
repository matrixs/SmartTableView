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
    var multiCellType = false
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
    
    func bindDataSource(dataSource: Array<NSObject>, delegate: AnyObject) {
        tableView?.dataSource = self
        tableView?.delegate = self
        forward = delegate
        data = dataSource
    }
    
    func registerClass(cellClass: AnyClass, dataSource: Array<NSObject>, delegate: AnyObject) {
        if cellIdentifier == nil {
            cellIdentifier = Identifiers.defaultIdentifier
        }
        bindDataSource(dataSource, delegate: delegate)
        tableView?.registerClass(cellClass, forCellReuseIdentifier: cellIdentifier!)
        self.cellClass = cellClass
    }
    
    func registerClass(cellClass: AnyClass, dataSource: Array<NSObject>, delegate: AnyObject, identifier: String) {
        self.cellIdentifier = identifier
        registerClass(cellClass, dataSource: dataSource, delegate: delegate)
    }
    
    func registerNib(nib: UINib, dataSource: Array<NSObject>, delegate: AnyObject) {
        if cellIdentifier == nil {
            cellIdentifier = Identifiers.defaultIdentifier
        }
        bindDataSource(dataSource, delegate: delegate)
        tableView?.registerNib(nib, forCellReuseIdentifier: cellIdentifier!)
    }
    
    func registerNib(nib: UINib, dataSource: Array<NSObject>, delegate: AnyObject, identifier: String) {
        self.cellIdentifier = identifier
        registerNib(nib, dataSource: dataSource, delegate: delegate)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let forward_ = forward else { return 1 }
        let selector = #selector(UITableViewDataSource.numberOfSectionsInTableView(_:))
        if forward_.respondsToSelector(selector) {
            return ((forward_.performSelector(selector, withObject: nil).takeUnretainedValue() as? NSNumber)?.integerValue)!
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forward_ = forward else { return 0 }
        let selector = #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
        if forward_.respondsToSelector(selector) {
            return ((forward_.performSelector(selector, withObject: tableView, withObject: section).takeUnretainedValue() as? NSNumber)?.integerValue)!
        }
        return data?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        guard let forward_ = forward else { return UITableViewCell() }
        let selector = #selector(UITableViewDataSource.tableView(_:cellForRowAtIndexPath:))
        if forward_.respondsToSelector(selector) {
            cell = forward_.performSelector(selector, withObject: tableView, withObject: indexPath).takeUnretainedValue() as? UITableViewCell
        }
        var identifier = self.cellIdentifier
        if multiCellType {
            identifier = identifierForRowAtIndexPath(indexPath)
        }
        if cell == nil {
            cell = tableView.dequeueReusableCellWithIdentifier(identifier!)
        }
        if cell == nil {
            let cellSelector = #selector(SmartTableViewImpl.cellClassForRowAtIndexPath(_:))
            if forward_.respondsToSelector(cellSelector) {
                cell = (forward_.performSelector(cellSelector, withObject: indexPath).takeUnretainedValue()) as? UITableViewCell
                let cellClass = (forward_.performSelector(cellSelector, withObject: indexPath).takeUnretainedValue()) as? UITableViewCell.Type
                cell = cellClass!.init(style: .Default, reuseIdentifier: identifier)
            } else if self.cellClass != nil {
                cell = (self.cellClass as? UITableViewCell.Type)!.init(style: .Default, reuseIdentifier: identifier)
            } else {
                cell = (cellClassForRowAtIndexPath(indexPath) as! UITableViewCell.Type).init(style: .Default, reuseIdentifier: identifier)
            }
        }
        cell?.fillData(data![indexPath.row])
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let forward_ = forward else { return 0 }
        let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAtIndexPath:))
        if forward_.respondsToSelector(selector) {
            return CGFloat((forward_.performSelector(selector, withObject: tableView, withObject: indexPath).takeUnretainedValue() as? NSNumber)!.floatValue)
        }
        if indexPath.row < heightArray.count && heightArray[indexPath.row] > 0 {
            return heightArray[indexPath.row]
        }
        return 0
    }
    
    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        return "\(cellIdentifier)\(indexPath.row)"
    }
    
    func cellClassForRowAtIndexPath(indexPath: NSIndexPath) -> AnyClass {
        return UITableViewCell.self
    }
    
    func calculateCellHeight(cell: UITableViewCell, data: NSObject) {
        cell.fillData(data)
        updateLayout(cell)
        let height = maxMarginBottomInSubviews(cell.contentView) + 1
        heightArray.append(height)
        constraintsCached = true
    }
    
    func maxMarginBottomInSubviews(view: UIView) -> CGFloat {
        var maxMarginBottom: CGFloat = 0
        if view.subviews.count > 0 {
            for subview in view.subviews {
                var height = maxMarginBottomInSubviews(subview)
                if constraintsCached {
                    let bottomValue = objc_getAssociatedObject(subview, &Identifiers.BottomKey)
                    if bottomValue != nil {
                        height += CGFloat(bottomValue.floatValue)
                    }
                    let bottomMarginValue = objc_getAssociatedObject(subview, &Identifiers.BottomMarginKey)
                    if bottomMarginValue != nil {
                        height += CGFloat(bottomMarginValue.floatValue)
                    }
                } else {
                    let array = view.constraints
                    for constraint in array {
                        if subview == constraint.firstItem as! NSObject {
                            let firstAttribute = constraint.firstAttribute
                            if firstAttribute == NSLayoutAttribute.Bottom {
                                let bottom = fabs(constraint.constant)
                                height += bottom
                                objc_setAssociatedObject(subview, &Identifiers.BottomKey, bottom, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                            }
                            if firstAttribute == NSLayoutAttribute.BottomMargin {
                                let bottomMargin = fabs(constraint.constant)
                                height += bottomMargin
                                objc_setAssociatedObject(subview, &Identifiers.BottomMarginKey, bottomMargin, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                            }
                        }
                    }
                }
                if height > maxMarginBottom {
                    maxMarginBottom = height
                }
            }
        } else {
            return view.frame.origin.y + view.bounds.size.height
        }
        return maxMarginBottom
    }
    
    func updateLayout(cell: UITableViewCell) {
        cell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView!.bounds), CGRectGetHeight(cell.bounds))
        cell.layoutIfNeeded()
    }
    
    func calcCellHeight() {
        if cell == nil {
            if self.cellClass == nil {
                cell = tableView?.dequeueReusableCellWithIdentifier(cellIdentifier!)
            } else {
                cell = (self.cellClass as! UITableViewCell.Type).init(style: .Default, reuseIdentifier: cellIdentifier)
            }   
        }
        if let data_ = data {
            for obj in data_ {
                calculateCellHeight(cell!, data: obj)
            }
        }
    }
}
