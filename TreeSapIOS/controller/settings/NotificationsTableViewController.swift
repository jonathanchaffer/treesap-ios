//
//  NotificationsTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Firebase
import UIKit

class NotificationsTableViewController: UITableViewController {
    // MARK: - Properties

    var documents = [DocumentSnapshot]()
    var selecting = false

    @IBOutlet var selectButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var barSpace: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataSuccess), name: NSNotification.Name("deleteDataSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataFailure), name: NSNotification.Name("deleteDataFailure"), object: nil)
    }

    override func viewWillAppear(_: Bool) {
        reloadNotifications()
        navigationController?.setToolbarHidden(false, animated: false)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return documents.count
    }

    /// Determines the cell to be displayed at a given index path.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        // Get the data for the cell
        let data = documents[indexPath.row].data()!
        let accepted = data["accepted"] as! Bool
        let treeData = data["treeData"] as! [String: Any]
        let commonName = NameFormatter.formatCommonName(commonName: treeData["commonName"] as? String)
        let read = data["read"] as! Bool
        if accepted {
            cell.textLabel!.text = "Tree Accepted"
            cell.detailTextLabel!.text = "Your \(commonName!) has been added to the database."
        } else {
            cell.textLabel!.text = "Tree Rejected"
            cell.detailTextLabel!.text = "Your \(commonName!) was removed from the database."
        }
        if read {
            cell.textLabel!.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        } else {
            cell.textLabel!.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        }
        if selecting {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    /// Function that is called when a table cell is selected. If selecting items, then the cell should be checked/unchecked when tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if selecting {
            // If selecting is active, select/deselect the cell appropriately
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
            } else {
                cell?.accessoryType = .checkmark
            }
        } else {
            let index = indexPath.row
            // If notification is unread, mark as read
            if !(documents[index]["read"] as! Bool) {
                DatabaseManager.markNotificationAsRead(documentID: documents[index].documentID)
            }
            // Push notification details for the cell
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notificationDetails") as! NotificationDetailsViewController
            vc.data = documents[index].data()!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Private functions

    /// Reloads the table data.
    @objc private func reloadTableData() {
        tableView.reloadData()
        reloadTableRows()
    }
    
    /// Reloads the table rows.
    private func reloadTableRows() {
        var rows = [IndexPath]()
        for i in 0 ..< documents.count {
            rows.append(IndexPath(row: i, section: 0))
        }
        tableView.reloadRows(at: rows, with: .automatic)
    }
    
    /// Asks the database manager for the notifications collection and reloads the notifications into documents.
    private func reloadNotifications() {
        DatabaseManager.getNotificationsCollection()?.getDocuments { snapshot, error in
            if error != nil {
                self.failedToLoad()
            } else {
                self.documents = []
                for document in snapshot!.documents {
                    self.documents.append(document)
                }
                self.reloadTableData()
            }
        }
    }

    /// Shows an alert saying that notifications could not be loaded.
    @objc private func failedToLoad() {
        let alert = UIAlertController(title: "Failed to load notifications", message: "An error occurred while trying to load notifications. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in self.closeNotifications() }))
        present(alert, animated: true)
    }
    
    /// Dismisses the loading alert and then reloads notifications and stops selection.
    @objc private func deleteDataSuccess() {
        dismiss(animated: true) {
            self.reloadNotifications()
            self.stopSelection()
        }
    }
    
    /// Dismisses the loading alert and then alerts the user that there was an error deleting data.
    @objc private func deleteDataFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: "Failed to delete notifications", message: "An error occurred while trying to delete notifications. Please try again.")
        }
    }

    /// Closes the notifications screen.
    private func closeNotifications() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    /// Stops selection, whether by hitting cancel or by hitting trash.
    private func stopSelection() {
        selecting = false
        reloadTableRows()
        navigationController?.toolbar.items = [selectButton, barSpace]
    }

    // MARK: - Actions

    @IBAction func selectButtonPressed(_: UIBarButtonItem) {
        selecting = true
        reloadTableRows()
        navigationController?.toolbar.items = [cancelButton, barSpace, trashButton]
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        stopSelection()
    }
    
    /// Shows an "Are you sure?" alert. If the user selects "Remove", tells the database manager to remove the selected notifications.
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Remove notifications?", message: "Are you sure you want to remove these notifications permanently?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
            var numNotificationsToDelete = 0
            for i in 0 ..< self.documents.count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath)
                if cell!.accessoryType == .checkmark {
                    numNotificationsToDelete += 1
                    DatabaseManager.removeDocumentFromNotifications(documentID: self.documents[i].documentID)
                }
            }
            if numNotificationsToDelete > 0 {
                AlertManager.showLoadingAlert()
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
}
