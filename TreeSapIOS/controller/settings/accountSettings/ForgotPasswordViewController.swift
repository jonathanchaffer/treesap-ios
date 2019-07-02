//
//  ForgotPasswordViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/24/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet var forgotPasswordEmailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(passwordResetSent), name: NSNotification.Name(StringConstants.passwordResetSentNotification), object: nil)
        forgotPasswordEmailTextField.delegate = self
    }

    private func sendPasswordResetEmail() {
        AccountManager.sendPasswordResetEmail(email: forgotPasswordEmailTextField.text!)
    }

    @objc private func passwordResetSent() {
        let alert = UIAlertController(title: StringConstants.passwordResetSentTitle, message: StringConstants.passwordResetSentMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default, handler: { _ in self.closeForgotPassword() }))
        present(alert, animated: true)
    }

    private func closeForgotPassword() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendPasswordResetButtonPressed(_: UIButton) {
        sendPasswordResetEmail()
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == forgotPasswordEmailTextField {
            sendPasswordResetEmail()
        }
        return true
    }
}
