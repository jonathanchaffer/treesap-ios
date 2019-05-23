//
//  DataSourceTableViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/23/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class DataSourceTableViewController: UITableViewController {
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataSources: [DataSource] = [DataSource]()

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSources = appDelegate.dataSources
    }
    
}
