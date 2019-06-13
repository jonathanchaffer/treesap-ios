//
//  DataSourceTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class DataSourceTableViewController: UITableViewController {
    // MARK: Properties

    var dataSources = [DataSource]()

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Active Data Sources"
        dataSources = DataManager.dataSources
        // Set the checkmarks based on the active status of the data sources
        DispatchQueue.main.async {
            for i in 0 ..< self.dataSources.count {
                let indexPath = NSIndexPath(row: i, section: 0)
                if PreferencesManager.isActive(dataSourceName: self.dataSources[i].dataSourceName) {
                    self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
                } else {
                    self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
                }
            }
        }
    }

    override func viewWillDisappear(_: Bool) {
        for i in 0 ..< dataSources.count {
            let indexPath = NSIndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            if cell!.accessoryType == .checkmark {
                PreferencesManager.activateDataSource(dataSourceName: cell!.textLabel!.text!)
            } else {
                PreferencesManager.deactivateDataSource(dataSourceName: cell!.textLabel!.text!)
            }
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataSources.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataSourceCell", for: indexPath)
        cell.textLabel?.text = dataSources[indexPath.row].dataSourceName
        return cell
    }

    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            PreferencesManager.deactivateDataSource(dataSourceName: cell!.textLabel!.text!)
        } else {
            cell?.accessoryType = .checkmark
            PreferencesManager.activateDataSource(dataSourceName: cell!.textLabel!.text!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
