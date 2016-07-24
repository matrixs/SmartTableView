//
//  ViewController.swift
//  SmartTableView
//
//  Created by matrixs on 16/7/24.
//  Copyright © 2016年 matrixs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataSource = [NSObject]()
        
        let tableView = UITableView(frame: view.frame, style: .Plain)
        view.addSubview(tableView)
        tableView.registerClass(SmartTestCell.self, dataSource: dataSource, delegate: self)
        dataSource.append(["txt":"ssssssss"])
        dataSource.append(["txt":"sssssssssssssssssssssssssssssssssssssssssssssss"])
        dataSource.append(["txt":"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss"])
        dataSource.append(["txt":"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss\nssssssss\nssssssss\nssssssss\nssssssss\ns\ns"])
        dataSource.append(["txt":"ssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\nssssssss\n\n\nssssssss\n\n\nssssssss\n\n\nssssssss"])
        dataSource.append(["txt":"ssssssssas\nssssssss\nsas\nssssssss\nas\n\nssssssss\n\nasdasd\nssssssss\nssssssssas\n\nasdas\n\n\nssssssss\nasd\nssssssss\n\nasdasd\nssssssss\nweqw\ne\nssssssss"])
        tableView.updateDataSource(dataSource)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

