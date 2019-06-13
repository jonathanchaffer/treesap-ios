//
//  AccountTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 6/12/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
	
	@IBOutlet weak var emailLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		refreshTable()
		title = "Account"
		NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name("loggedIn"), object: nil)
    }
	
	/// Deselects a row when it is selected.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath == IndexPath(row: 2, section: 0) {
			logOutPressed()
		}
	}
	
	/// Sets the height of cells depending on whether the user is logged in or not.
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if AccountManager.isLoggedIn() {
			if indexPath == IndexPath(row: 0, section: 0) {
				return 0
			}
		} else {
			if indexPath == IndexPath(row: 1, section: 0) || indexPath == IndexPath(row: 2, section: 0) {
				return 0
			}
		}
		return tableView.estimatedRowHeight
	}
	
	func logOutPressed() {
		let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to log out?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.logOut() }))
		present(alert, animated: true)
	}
	
	func logOut() {
		if !AccountManager.logOut() {
			AlertManager.alertUser(title: "Error", message: "There was an error when trying to log out. Please try again.")
		} else {
			tableView.reloadData()
		}
	}
	
	@objc func refreshTable() {
		emailLabel.text = AccountManager.getEmail()
		tableView.reloadData()
	}
}
