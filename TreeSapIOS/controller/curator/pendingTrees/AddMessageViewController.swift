//
//  AddMessageViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddMessageViewController: UIViewController {
    // MARK: - Properties

    var accepting: Bool?
    var documentID: String?
    var userID: String?
    @IBOutlet var textField: MultilineTextField!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Private functions

    private func closeAddMessage() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func cancelButtonPressed(_: UIBarButtonItem) {
        closeAddMessage()
    }

    @IBAction func saveButtonPressed(_: UIButton) {
        // Ensure connection
        if !NetworkManager.isConnected {
            AlertManager.alertUser(title: StringConstants.noConnectionTitle, message: StringConstants.noConnectionMessage)
            return
        }
        if accepting! {
            let alert = UIAlertController(title: StringConstants.confirmAcceptTreeTitle, message: StringConstants.confirmAcceptTreeMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: StringConstants.confirmAcceptTreeAcceptAction, style: .default) { _ in
                DatabaseManager.sendNotificationToUser(userID: self.userID!, accepted: self.accepting!, message: self.textField.text, documentID: self.documentID!)
                DatabaseManager.acceptDocumentFromPending(documentID: self.documentID!)
                AlertManager.showLoadingAlert()
            })
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: StringConstants.confirmRejectTreeTitle, message: StringConstants.confirmRejectTreeMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: StringConstants.confirmRejectTreeRejectAction, style: .default) { _ in
                DatabaseManager.sendNotificationToUser(userID: self.userID!, accepted: self.accepting!, message: self.textField.text, documentID: self.documentID!)
                DatabaseManager.rejectDocumentFromPending(documentID: self.documentID!)
                AlertManager.showLoadingAlert()
            })
            present(alert, animated: true)
        }
    }
}
