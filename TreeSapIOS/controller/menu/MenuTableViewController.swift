//
//  MenuTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class MenuTableViewController: UITableViewController {

    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !AccountManager.isCurator() && indexPath.row == 2 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 {
            sendEmail()
        }
    }
    
    // MARK: - Private Functions
    
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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        // TODO: Make this work
        if result == .sent {
            AlertManager.alertUser(title: StringConstants.feedbackSentTitle, message: StringConstants.feedbackSentMessage)
        }
    }
}
