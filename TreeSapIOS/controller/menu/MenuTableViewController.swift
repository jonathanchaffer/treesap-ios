//
//  MenuTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

class MenuTableViewController: UITableViewController {
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }

    /// Sets the height of each table row.
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !AccountManager.isCurator(), indexPath.row == 2, indexPath.section == 0 {
            return 0
        }
        if !AccountManager.isLoggedIn(), indexPath.row == 1, indexPath.section == 1 {
            return 0
        }
        if AccountManager.isLoggedIn(), indexPath.row == 0, indexPath.section == 1 {
            return 0
        }
        return UITableView.automaticDimension
    }

    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3, indexPath.section == 0 {
            sendEmail()
        }
        if indexPath.row == 1, indexPath.section == 1 {
            logOutPressed()
        }
    }

    // MARK: - Private Functions

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

    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["feedback@treesap.info"])
            mail.setSubject("TreeSap Feedback")
            present(mail, animated: true)
        } else {
            AlertManager.alertUser(title: StringConstants.errorComposingEmailTitle, message: StringConstants.errorComposingEmailMessage)
        }
    }
}

extension MenuTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error _: Error?) {
        controller.dismiss(animated: true)
        // TODO: Make this work
        if result == .sent {
            AlertManager.alertUser(title: StringConstants.feedbackSentTitle, message: StringConstants.feedbackSentMessage)
        }
    }
}
