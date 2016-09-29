//
//  UITableView+SmartTableView.swift
//  SmartTableView
//
//  Created by matrixs on 16/7/24.
//  Copyright © 2016年 matrixs. All rights reserved.
//

import UIKit

extension UITableView {
    
    private struct AssociatedKeys {
        static var SmartTableViewImplKey =  "SmartTableViewImpl"
    }
    
    var tableViewImpl : SmartTableViewImpl {
        get {
            var tableViewImpl = objc_getAssociatedObject(self, &AssociatedKeys.SmartTableViewImplKey)
            if tableViewImpl == nil {
                tableViewImpl = SmartTableViewImpl()
                objc_setAssociatedObject(self, &AssociatedKeys.SmartTableViewImplKey, tableViewImpl, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return tableViewImpl as! SmartTableViewImpl
        }
    }
    
    open override class func initialize() {
        if  self !== UITableView.self {
            return
        }
        let _: () = {
            let reloadDataSEL = #selector(reloadData)
            let reloadDataMethod = class_getInstanceMethod(self, reloadDataSEL)
            let reloadDataIMP = method_getImplementation(reloadDataMethod)
            
            let smartReloadDataSEL = #selector(smartReloadData)
            let smartReloadDataMethod = class_getInstanceMethod(self, smartReloadDataSEL)
            let smartReloadDataIMP = method_getImplementation(smartReloadDataMethod)
            
            let didAddMethod = class_addMethod(self, reloadDataSEL, smartReloadDataIMP, method_getTypeEncoding(smartReloadDataIMP))
            if didAddMethod {
                class_replaceMethod(self, smartReloadDataSEL, reloadDataIMP, method_getTypeEncoding(reloadDataMethod))
            } else {
                method_exchangeImplementations(reloadDataMethod, smartReloadDataMethod)
            }
        }()
    }
    
    func smartReloadData() {
        let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
        if tableViewImpl.forward == nil || !tableViewImpl.forward!.responds(to: selector){
            tableViewImpl.calcCellHeight()
        }
        smartReloadData()
    }
    
    func config() {
        self.tableViewImpl.tableView = self
        self.tableFooterView = UIView()
    }
    
    func bindDataSource(dataSource: [NSObject], delegate: AnyObject) {
        config()
        self.tableViewImpl.bindDataSource(dataSource: dataSource, delegate: delegate)
    }
    
    public func sma_updateDataSource(dataSource: [NSObject]) {
        self.tableViewImpl.data?.removeAll()
        self.tableViewImpl.data?.append(contentsOf: dataSource)
    }
    
    public func registerNib(nib: UINib, dataSource: [NSObject], delegate: AnyObject, identifier: String) {
        config()
        self.tableViewImpl.registerNib(nib: nib, dataSource: dataSource, delegate: delegate, identifier: identifier)
    }
    
    public func registerNib(nib: UINib, dataSource: [NSObject], delegate: AnyObject) {
        config()
        self.tableViewImpl.registerNib(nib: nib, dataSource: dataSource, delegate: delegate)
    }
    
    public func registerClass(cellClass: AnyClass, dataSource: [NSObject], delegate: AnyObject, identifier: String) {
        config()
        self.tableViewImpl.registerClass(cellClass: cellClass, dataSource: dataSource, delegate: delegate, identifier: identifier)
    }
    
    public func registerClass(cellClass: AnyClass, dataSource: [NSObject], delegate: AnyObject) {
        config()
        self.tableViewImpl.registerClass(cellClass: cellClass, dataSource: dataSource, delegate: delegate)
    }
}
