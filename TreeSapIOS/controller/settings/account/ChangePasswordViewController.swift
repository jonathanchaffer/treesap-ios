//
//  ChangePasswordViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/24/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(closeChangePassword), name: NSNotification.Name(StringConstants.passwordUpdatedNotification), object: nil)
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        updatePassword()
    }
    
    
    private func updatePassword() {
        if newPasswordTextField.text! == newPasswordConfirmTextField.text! {
            AccountManager.updatePassword(oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!)
        } else {
            AlertManager.alertUser(title: StringConstants.unmatchingPasswordsTitle, message: StringConstants.unmatchingPasswordsMessage)
            return
        }
    }
    
    @objc private func closeChangePassword() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case oldPasswordTextField:
            newPasswordTextField.becomeFirstResponder()
        case newPasswordTextField:
            newPasswordConfirmTextField.becomeFirstResponder()
        case newPasswordConfirmTextField:
            updatePassword()
        default:
            return true
        }
        return true
    }
}
