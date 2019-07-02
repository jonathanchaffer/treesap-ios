//
//  AccountTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 6/12/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    // MARK: - Properties

    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    let numRowsPerSection = [1, 5]
    let sectionHeaders: [String?] = ["Account", "Account"]

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTable()
        title = "Account"
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(StringConstants.loggedInNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(StringConstants.displayNameUpdatedNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshTable()
    }

    /// Deselects a row when it is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: numRowsPerSection[1] - 1, section: 1) {
            logOutPressed()
        }
    }

    /// Sets the number of rows for each section.
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        var myNumRowsPerSection = numRowsPerSection
        if AccountManager.isLoggedIn() {
            myNumRowsPerSection[0] = 0
        } else {
            myNumRowsPerSection[1] = 0
        }
        return myNumRowsPerSection[section]
    }

    /// Sets the title of each section's header.
    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        var mySectionHeaders = sectionHeaders
        if AccountManager.isLoggedIn() {
            mySectionHeaders[0] = nil
        } else {
            mySectionHeaders[1] = nil
        }
        return mySectionHeaders[section]
    }

    /// Sets the height of each section's header.
    override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AccountManager.isLoggedIn(), section == 0 {
            return 0.01
        } else if !AccountManager.isLoggedIn(), section == 1 {
            return 0.01
        }
        return UITableView.automaticDimension
    }

    /// Sets the height of each section's footer.
    override func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if AccountManager.isLoggedIn(), section == 0 {
            return 0.01
        } else if !AccountManager.isLoggedIn(), section == 1 {
            return 0.01
        }
        return UITableView.automaticDimension
    }

    // MARK: - Private functions

    private func logOutPressed() {
        let alert = UIAlertController(title: StringConstants.confirmLogOutTitle, message: StringConstants.confirmLogOutMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.confirmLogOutLogOutAction, style: .default, handler: { _ in self.logOut() }))
        present(alert, animated: true)
    }

    private func logOut() {
        if !AccountManager.logOut() {
            AlertManager.alertUser(title: StringConstants.failedToLogOutTitle, message: StringConstants.failedToLogOutMessage)
        } else {
            tableView.reloadData()
        }
    }

    @objc private func refreshTable() {
        let displayName = AccountManager.getDisplayName()
        let email = AccountManager.getEmail()
        if displayName != nil {
            displayNameLabel.text = displayName
        } else {
            displayNameLabel.text = email
        }
        emailLabel.text = email
        tableView.reloadData()
    }
}
