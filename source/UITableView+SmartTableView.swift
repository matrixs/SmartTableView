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
    
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        if  self !== UITableView.self {
            return
        }
        dispatch_once(&Static.token) { 
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
        }
    }
    
    func smartReloadData() {
        let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAtIndexPath:))
        if tableViewImpl.forward == nil || !tableViewImpl.forward!.respondsToSelector(selector){
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
        self.tableViewImpl.bindDataSource(dataSource, delegate: delegate)
    }
    
    func updateDataSource(dataSource: [NSObject]) {
        self.tableViewImpl.data = dataSource
    }
    
    func registerNib(nib: UINib, dataSource: [NSObject], delegate: AnyObject, identifier: String) {
        config()
        self.tableViewImpl.registerNib(nib, dataSource: dataSource, delegate: delegate, identifier: identifier)
    }
    
    func registerNib(nib: UINib, dataSource: [NSObject], delegate: AnyObject) {
        config()
        self.tableViewImpl.registerNib(nib, dataSource: dataSource, delegate: delegate)
    }
    
    func registerClass(cellClass: AnyClass, dataSource: [NSObject], delegate: AnyObject, identifier: String) {
        config()
        self.tableViewImpl.registerClass(cellClass, dataSource: dataSource, delegate: delegate, identifier: identifier)
    }
    
    func registerClass(cellClass: AnyClass, dataSource: [NSObject], delegate: AnyObject) {
        config()
        self.tableViewImpl.registerClass(cellClass, dataSource: dataSource, delegate: delegate)
    }
}
