//
//  NotificationsTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Firebase

class NotificationsTableViewController: UITableViewController {
    // MARK: - Properties
    var documents = [DocumentSnapshot]()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DatabaseManager.getNotificationsCollection()?.getDocuments() { snapshot, error in
            if error != nil {
                self.failedToLoad()
            } else {
                for document in snapshot!.documents {
                    self.documents.append(document)
                }
                self.reloadTableData()
            }
        }
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        // Get the data for the cell
        let data = documents[indexPath.row].data()!
        let accepted = data["accepted"] as! Bool
        let treeData = data["treeData"] as! [String:Any]
        let commonName = NameFormatter.formatCommonName(commonName: treeData["commonName"] as? String)
        if accepted {
            cell.textLabel!.text = "Tree Accepted"
            cell.detailTextLabel!.text = "Your \(commonName!) is now available for everyone to see."
        } else {
            cell.textLabel!.text = "Tree Rejected"
            cell.detailTextLabel!.text = "Your \(commonName!) was removed from the database."
        }
        return cell
    }
    
    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Reloads the table data.
    @objc private func reloadTableData() {
        tableView.reloadData()
    }
    
    /// Shows an alert saying that pending trees could not be loaded.
    @objc private func failedToLoad() {
        let alert = UIAlertController(title: "Failed to load notifications", message: "An error occurred while trying to load notifications. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in self.closeNotifications() }))
        present(alert, animated: true)
    }
    
    /// Closes the list of pending trees.
    private func closeNotifications() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
