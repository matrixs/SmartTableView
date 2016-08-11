//
//  ViewController.swift
//  SmartTableView
//
//  Created by matrixs on 16/7/24.
//  Copyright © 2016年 matrixs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var dataSource = [NSObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tableView = UITableView(frame: view.frame, style: .Plain)
        view.addSubview(tableView)
        tableView.registerClass(SmartTestCell.self, dataSource: dataSource, delegate: self, identifier: "CELL1")
        tableView.registerClass(SmartTestCell2.self, dataSource: dataSource, delegate: self, identifier: "CELL2")
        dataSource.append(["txt":"ssssssss", "type": 1])
        dataSource.append(["txt":"sssssssssssssssssssssssssssssssssssssssssssssss", "type": 1])
        dataSource.append(["txt":"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss", "type": 2])
        dataSource.append(["txt":"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss\nssssssss\nssssssss\nssssssss\nssssssss\ns\ns", "type": 1])
        dataSource.append(["txt":"ssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\n\n\nssssssss\n\n\nssssssss\n\n\nssssssss", "type": 2])
        dataSource.append(["txt":"ssssssssas\nssssssss\nsas\nssssssss\nas\n\nssssssss\n\nasdasd\nssssssss\nssssssssas\n\nasdas\n\n\nssssssss\nasd\nssssssss\n\nasdasd\nssssssss\nweqw\ne\nssssssss", "type": 1])
        tableView.sma_updateDataSource(dataSource)
        tableView.reloadData()
    }
    
    func identifierForRow(row: NSNumber) -> String {
        let dict = dataSource[row.integerValue] as! NSDictionary
        if dict["type"]?.integerValue == 1 {
            return "CELL1"
        } else {
            return "CELL2"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

