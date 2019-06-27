//
//  AddMessageViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/27/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddMessageViewController: UIViewController {
    
    // MARK: - Properties
    var accepting: Bool?
    var documentID: String?
    var userID: String?
    @IBOutlet weak var textField: MultilineTextField!
    
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
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.closeAddMessage()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if accepting! {
            let alert = UIAlertController(title: "Accept tree?", message: "This tree will be added to the online database for everyone to see.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Accept", style: .default) { _ in
                DatabaseManager.sendNotificationToUser(userID: self.userID!, accepted: self.accepting!, message: self.textField.text, documentID: self.documentID!)
                DatabaseManager.acceptDocumentFromPending(documentID: self.documentID!)
                AlertManager.showLoadingAlert()
            })
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Reject tree?", message: "This tree will be removed from the database.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Reject", style: .default) { _ in
                DatabaseManager.sendNotificationToUser(userID: self.userID!, accepted: self.accepting!, message: self.textField.text, documentID: self.documentID!)
                DatabaseManager.rejectDocumentFromPending(documentID: self.documentID!)
                AlertManager.showLoadingAlert()
            })
            present(alert, animated: true)
        }
    }
    
}
