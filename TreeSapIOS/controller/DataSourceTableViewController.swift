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
    var dataSources = [DataSource]()

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSources = appDelegate.dataSources
        // Set the checkmarks based on the active status of the data sources
        DispatchQueue.main.async {
            for i in 0 ..< self.dataSources.count {
                let indexPath = NSIndexPath(row: i, section: 0)
                if self.dataSources[i].isActive {
                    self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
                } else {
                    self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for i in 0 ..< dataSources.count {
            let indexPath = NSIndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            if cell!.accessoryType == .checkmark {
                appDelegate.activateDataSource(dataSourceName: cell!.textLabel!.text!)
            } else {
                appDelegate.deactivateDataSource(dataSourceName: cell!.textLabel!.text!)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataSourceCell", for: indexPath)
        cell.textLabel?.text = dataSources[indexPath.row].dataSourceName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
