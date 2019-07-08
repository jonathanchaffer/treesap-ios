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

    ///An array of Firebase document snapshots that contain the notification data
    var documents = [DocumentSnapshot]()
    ///Stores whether or not a notification is selected and is organized based on a notification index in the table
    var selectedDictionary = [Bool]()
    ///If the user is selecting a set of notifications for potential deletion
    var selecting = false
    ///The number of pending notification deletions
    var numPendingDeletions = 0
    ///If there was an error in one of the notification deletions in a selection of notification deletions
    var isDeletionError = false

    @IBOutlet var selectButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var barSpace: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataSuccess), name: NSNotification.Name(StringConstants.deleteDataSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataFailure), name: NSNotification.Name(StringConstants.deleteDataFailureNotification), object: nil)

        // Setup long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }

    override func viewWillAppear(_: Bool) {
        reloadNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.stopSelection()
        }
        navigationController?.setToolbarHidden(false, animated: false)
    }

    override func viewDidAppear(_: Bool) {
        // Prompt the user to log in if they're not already
        if !AccountManager.isLoggedIn() {
            let alert = UIAlertController(title: StringConstants.loginRequiredTitle, message: StringConstants.loginRequiredMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: { _ in self.closeNotifications() }))
            alert.addAction(UIAlertAction(title: StringConstants.loginRequiredLogInAction, style: .default, handler: { _ in self.goToLogin() }))
            present(alert, animated: true)
        }
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
            cell.detailTextLabel!.text = "Your \(commonName!) was not added to the database."
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
            navigationController?.pushViewController(vc, animated: true)
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
        tableView.reloadRows(at: rows, with: .none)
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
                self.documents.sort(by: { doc1, doc2 in
                    (doc1.data()!["timestamp"] as! Timestamp).seconds > (doc2.data()!["timestamp"] as! Timestamp).seconds
                }, stable: true)
                self.reloadTableData()
            }
        }
    }

    /// Pushes the login screen onto the view hierarchy.
    @objc private func goToLogin() {
        let screen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSignupScreen")
        navigationController?.pushViewController(screen, animated: true)
    }

    /// Shows an alert saying that notifications could not be loaded.
    @objc private func failedToLoad() {
        let alert = UIAlertController(title: StringConstants.failedToLoadNotificationsTitle, message: StringConstants.failedToLoadNotificationsMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.ok, style: .cancel, handler: { _ in self.closeNotifications() }))
        present(alert, animated: true)
    }

    /// Dismisses the loading alert and then reloads notifications and stops selection.
    @objc private func deleteDataSuccess() {
        numPendingDeletions -= 1
        if numPendingDeletions == 0 {
            dismiss(animated: true) {
                self.reloadNotifications()
                self.stopSelection()
            }
        }
    }

    /// Dismisses the loading alert and then alerts the user that there was an error deleting data
    @objc private func deleteDataFailure() {
        isDeletionError = true
        numPendingDeletions -= 1
        if(numPendingDeletions == 0){
            dismiss(animated: true) {
                if(self.isDeletionError){
                    AlertManager.alertUser(title: StringConstants.failedToDeleteNotificationsTitle, message: StringConstants.failedToLoadNotificationsMessage)
                    self.isDeletionError = false
                }
                self.reloadNotifications()
                self.stopSelection()
            }
        }
    }

    /// Starts selection when a cell is long pressed.
    @objc private func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        if !selecting {
            let location = longPressGesture.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: location)
            if longPressGesture.state == UIGestureRecognizer.State.began {
                startSelection()
                let cell = tableView.cellForRow(at: indexPath!)
                cell?.accessoryType = .checkmark
            }
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

    /// Starts selection, whether by hitting Select or holding down on one of the cells.
    private func startSelection() {
        selecting = true
        reloadTableRows()
        navigationController?.toolbar.items = [cancelButton, barSpace, trashButton]
    }

    // MARK: - Actions

    @IBAction func selectButtonPressed(_: UIBarButtonItem) {
        startSelection()
    }

    @IBAction func cancelButtonPressed(_: UIBarButtonItem) {
        stopSelection()
    }

    /// Shows an "Are you sure?" alert. If the user selects "Remove", tells the database manager to remove the selected notifications.
    @IBAction func trashButtonPressed(_: UIBarButtonItem) {
        let alert = UIAlertController(title: StringConstants.confirmDeleteNotificationsTitle, message: StringConstants.confirmDeleteNotificationsMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.confirmDeleteNotificationsDeleteAction, style: .destructive) { _ in
            self.numPendingDeletions = 0
            for i in 0 ..< self.documents.count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath)
                if cell!.accessoryType == .checkmark {
                    self.numPendingDeletions += 1
                    DatabaseManager.removeDocumentFromNotifications(documentID: self.documents[i].documentID)
                }
            }
            if self.numPendingDeletions > 0 {
                AlertManager.showLoadingAlert()
            }else{
                self.stopSelection()    //for if no notifications were selected
            }
        })
        present(alert, animated: true, completion: nil)
    }

    @IBAction func closeButtonPressed(_: UIBarButtonItem) {
        closeNotifications()
    }
}
