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
    // MARK: - Properties

    let sectionHeaders = ["Menu", "Curator", "Account"]
    @IBOutlet var notificationBadgeView: UIView!
    @IBOutlet var notificationBadgeLabel: UILabel!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        notificationBadgeView.layer.cornerRadius = notificationBadgeView.frame.height / 2
        notificationBadgeView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationBadge), name: NSNotification.Name(StringConstants.unreadNotificationsCountNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: NSNotification.Name(StringConstants.loggedInNotification), object: nil)
        updateNotificationBadge()
        UnreadManager.retrieveNumberOfUnreadNotifications()
    }

    /// Sets the height of each table row.
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Curator section
        if indexPath.section == 1 {
            if !AccountManager.isCurator() { return 0 }
            else if indexPath.row == 2, !AccountManager.isSuperCurator() {
                return 0  // no "add curator"
            }
            else if indexPath.row == 3, !AccountManager.isSuperCurator() {
                return 0  // no "delete curator"
            }
        }
        
        // Log in or out
        if indexPath.section == 2 {
            if indexPath.row == 0, AccountManager.isLoggedIn() {
                return 0     // turn off "Log in"
            } else if indexPath.row == 1, !AccountManager.isLoggedIn() {
                return 0     // turn off "Log out"
            }
        }
        return UITableView.automaticDimension
    }

    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // "Send Feedback"
        if indexPath.section == 0, indexPath.row == 2 {
            sendEmail()
        }
        
        // Export User Trees
        else if indexPath.section == 1, indexPath.row == 2 {
            exportUserTrees()
        }
            
        // Log in
        else if indexPath.section == 2, indexPath.row == 0 {
        }
        
        // Log out
        else if indexPath.section == 2, indexPath.row == 1 {
            logOutPressed()
        }
    }

    /// Sets the header for each section.
    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !AccountManager.isCurator(), section == 1 {
            return nil
        }
        return sectionHeaders[section]
    }

    /// Sets the height for each section's header.
    override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !AccountManager.isCurator(), section == 1 {
            return 0.01
        }
        return 0
    }

    /// Sets the height for each section's footer.
    override func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !AccountManager.isCurator(), section == 1 {
            return 0.01
        }
        return 0
    }
    
    // MARK: - Private Functions

    @objc private func updateNotificationBadge() {
        if UnreadManager.numUnreadNotifications > 0 {
            notificationBadgeView.isHidden = false
            notificationBadgeLabel.text = String(UnreadManager.numUnreadNotifications)
        }
    }
    
    @objc private func userLoggedIn() {
        tableView.reloadData()
    }

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

    private func exportUserTrees() {
        if let userTreesDataSource = DataManager.getDataSourceWithName(name: "User Trees") {
            let trees = userTreesDataSource.getTreeList()
            let fileName = "userTrees.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            // Create the csv text
            var csvText = "commonName,scientificName,latitude,longitude,dbh1,dbh2,dbh3,dbh4,userID,timestamp,documentID\n"
            for tree in trees {
                if tree.commonName != nil {
                    csvText.append("\"" + tree.commonName! + "\"")
                }
                csvText.append(",")
                if tree.scientificName != nil {
                    csvText.append("\"" + tree.scientificName! + "\"")
                }
                csvText.append(",")
                csvText.append(String(tree.location.latitude) + ",")
                csvText.append(String(tree.location.longitude) + ",")
                for i in 0 ..< 4 {
                    if tree.dbhArray.count > i {
                        csvText.append(String(tree.dbhArray[i]))
                    }
                    csvText.append(",")
                }
                if tree.userID != nil {
                    csvText.append("\"" + tree.userID! + "\"")
                }
                csvText.append(",")
                if tree.timestamp != nil {
                    csvText.append(String(tree.timestamp!))
                }
                csvText.append(",")
                if tree.documentID != nil {
                    csvText.append("\"" + tree.documentID! + "\"")
                }
                csvText.append("\n")
            }
            // Write the csv text to the file
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                AlertManager.alertUser(title: StringConstants.exportDataFailureTitle, message: StringConstants.exportDataFailureMessage)
            }
            // Present the activity view controller
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        } else {
            AlertManager.alertUser(title: StringConstants.exportDataFailureTitle, message: StringConstants.exportDataFailureMessage)
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
