//
//  AddCuratorViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddCuratorViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var emailTextField: UITextField!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(addCuratorFailed), name: NSNotification.Name(StringConstants.addCuratorFailureNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCuratorFailed), name: NSNotification.Name(StringConstants.updateDataFailureNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCuratorFailed), name: NSNotification.Name(StringConstants.submitDataFailureNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCuratorSuccess), name: NSNotification.Name(StringConstants.updateDataSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCuratorSuccess), name: NSNotification.Name(StringConstants.submitDataSuccessNotification), object: nil)
    }

    // MARK: - Private functions

    private func addCurator() {
        // Ensure connection
        if !NetworkManager.isConnected {
            AlertManager.alertUser(title: StringConstants.noConnectionTitle, message: StringConstants.noConnectionMessage)
            return
        }
        DatabaseManager.addCurator(email: emailTextField.text!)
        DatabaseManager.reloadCurators()
        AlertManager.showLoadingAlert()
    }

    @objc func addCuratorFailed() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: StringConstants.addCuratorFailureTitle, message: StringConstants.addCuratorFailureMessage)
        }
    }

    @objc func addCuratorSuccess() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: StringConstants.addCuratorSuccessTitle, message: StringConstants.addCuratorSuccessMessage)
        }
    }

    private func closeAddCurator() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func addCuratorButtonPressed(_: UIButton) {
        addCurator()
    }

    @IBAction func closeButtonPressed(_: UIBarButtonItem) {
        closeAddCurator()
    }
}
