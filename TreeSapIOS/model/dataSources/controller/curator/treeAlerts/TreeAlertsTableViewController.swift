//
//  NotificationsTableViewController.swift
//  TreeSapIOS
//
//  Created by Mike Jipping during summer 2020.
//  Copyright © 2019-2020 Hope CS. All rights reserved.
//

import Firebase
import UIKit

class TreeAlertsTableViewController: UITableViewController {
    // MARK: - Properties

    /// An array of Firebase document snapshots that contain the notification data
    var documents = [DocumentSnapshot]()
    /// Stores whether or not a notification at a given index is selected for every index.
    var selectedArray = [Bool]()
    /// If the user is selecting a set of notifications for potential deletion
    var selecting = false
    /// The number of pending notification deletions
    var numPendingDeletions = 0
    /// If there was an error in one of the notification deletions in a selection of notification deletions
    var isDeletionError = false

    @IBOutlet var selectButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var barSpace: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataSuccess), name: NSNotification.Name(StringConstants.deleteDataSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataFailure), name: NSNotification.Name(StringConstants.deleteDataFailureNotification), object: nil)

        // Setup long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }

    override func viewWillAppear(_: Bool) {
        reloadAlerts()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "treeAlertsCell", for: indexPath)
        // Get the data for the cell
        let data = documents[indexPath.row].data()!
        let reason = data["reason"] as! String
        let commonName = NameFormatter.formatCommonName(commonName: data["commonName"] as? String)

        if reason == "wrongIdentification" {
            cell.textLabel!.text = "Wrong ID"
            cell.detailTextLabel!.text = "Claim: A(n) \(commonName!) has been misidentified."
        } else if reason == "treeRemoved"{
            cell.textLabel!.text = "Tree Removed"
            cell.detailTextLabel!.text = "Claim: A(n) \(commonName!) has been added removed."
        } else {
            cell.textLabel!.text = "Tree Replaced"
            cell.detailTextLabel!.text = "Claim: A(n) \(commonName!) has been replaced with another tree."
        }
        cell.textLabel!.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        if selecting {
            if selectedArray[indexPath.row] {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        return cell
    }

    /// Function that is called when a table cell is selected. If selecting items, then the cell should be checked/unchecked when tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selecting {
            // If selecting is active, select/deselect the cell appropriately
            selectCell(indexPath: indexPath)
        } else {
            let index = indexPath.row
            // Push alert details for the cell
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "treeAlertDetails") as! TreeAlertDetailsViewController
            vc.data = documents[index].data()!
            vc.docID = documents[index].documentID
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
    private func reloadAlerts() {
        // Ensure connection
        if !NetworkManager.isConnected {
            AlertManager.alertUser(title: StringConstants.noConnectionTitle, message: StringConstants.noConnectionMessage)
            return
        }
        DatabaseManager.getTreeAlertsCollection()?.getDocuments { snapshot, error in
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

            // Set up the array that stores which cells are selected
            for _ in self.documents {
                self.selectedArray.append(false)
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
                self.removeDeletedFromArray()
                self.reloadAlerts()
                self.stopSelection()
            }
        }
    }

    /// Dismisses the loading alert and then alerts the user that there was an error deleting data
    @objc private func deleteDataFailure() {
        isDeletionError = true
        numPendingDeletions -= 1
        if numPendingDeletions == 0 {
            dismiss(animated: true) {
                if self.isDeletionError {
                    AlertManager.alertUser(title: StringConstants.failedToDeleteNotificationsTitle, message: StringConstants.failedToLoadNotificationsMessage)
                    self.isDeletionError = false
                }
                self.removeDeletedFromArray()
                self.reloadAlerts()
                self.stopSelection()
            }
        }
    }

    /// Starts selection when a cell is long pressed.
    @objc private func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        if selecting {
            return
        }

        let location = longPressGesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return // If no cell can be determined to have been pressed, nothing should happen
        }

        if longPressGesture.state == UIGestureRecognizer.State.began {
            startSelection()
            selectCell(indexPath: indexPath)
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

        // Set the array that stores whether cells are selected so that it stores all cells as being currently unselected
        for index in 0 ..< selectedArray.count {
            selectedArray[index] = false
        }

        reloadTableRows()
        navigationController?.toolbar.items = [selectButton, barSpace]
    }

    /// Starts selection, whether by hitting Select or holding down on one of the cells.
    private func startSelection() {
        selecting = true
        reloadTableRows()
        navigationController?.toolbar.items = [cancelButton, barSpace, trashButton]
    }

    /// Accounts for the deletion of a selection of notifications by removing from the array that keeps track of which notifications are selected all booleans that indicate that a notification was selected.
    private func removeDeletedFromArray() {
        for index in stride(from: selectedArray.count - 1, through: 0, by: -1) {
            if selectedArray[index] {
                selectedArray.remove(at: index)
            }
        }
    }

    // TODO: Document this
    private func selectCell(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let willBeSelected = !selectedArray[indexPath.row]

        // Flip whether cell is selected
        selectedArray[indexPath.row] = willBeSelected

        // Cell should have a checkmark if selected and no accessory type otherwise
        if willBeSelected {
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
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
        let alert = UIAlertController(title: StringConstants.confirmDeleteAlertsTitle, message: StringConstants.confirmDeleteAlertsMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.confirmDeleteAlertsDeleteAction, style: .destructive) { _ in
            self.numPendingDeletions = 0

            for i in 0 ..< self.selectedArray.count {
                if self.selectedArray[i] {
                    self.numPendingDeletions += 1
                    DatabaseManager.removeDocumentFromAlerts(documentID: self.documents[i].documentID)
                }
            }

            if self.numPendingDeletions > 0 {
                AlertManager.showLoadingAlert()
            } else {
                self.stopSelection() // for if no notifications were selected
            }

        })

        present(alert, animated: true, completion: nil)
    }

    @IBAction func closeButtonPressed(_: UIBarButtonItem) {
        closeNotifications()
    }
}
