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
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }

    /// Sets the height of each table row.
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !AccountManager.isCurator(), indexPath.section == 1 {
            return 0
        }
        if !AccountManager.isLoggedIn(), indexPath.row == 1, indexPath.section == 2 {
            return 0
        }
        if AccountManager.isLoggedIn(), indexPath.row == 0, indexPath.section == 2 {
            return 0
        }
        return UITableView.automaticDimension
    }

    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2, indexPath.section == 0 {
            sendEmail()
        }
        if indexPath.row == 2, indexPath.section == 1 {
            exportUserTrees()
        }
        if indexPath.row == 1, indexPath.section == 2 {
            logOutPressed()
        }
    }
    
    /// Sets the header for each section.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !AccountManager.isCurator(), section == 1 {
            return nil
        }
        return sectionHeaders[section]
    }
    
    /// Sets the height for each section's header.
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !AccountManager.isCurator(), section == 1 {
            return 0.01
        }
        return 0
    }
    
    /// Sets the height for each section's footer.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !AccountManager.isCurator(), section == 1 {
            return 0.01
        }
        return 0
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
