//
//  ChangeEmailViewController.swift
//  TreeSapIOS
//
//  Created by Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var newEmailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()

        NotificationCenter.default.addObserver(self, selector: #selector(closeChangeEmail), name: NSNotification.Name(StringConstants.emailUpdatedNotification), object: nil)

        passwordTextField.delegate = self
        newEmailTextField.delegate = self
    }

    @IBAction func changeEmailButtonPress(_: UIButton) {
        changeEmail()
    }

    /// If the password entered in the password entry text field is correct, this function requests that Firebase change the current user's e-mail to the e-mail specified in the text field or, if there is no current user, does nothing. Otherwise, the user is informed that the entered password was not correct.
    func changeEmail() {
        guard let passwordText = passwordTextField.text else {
            AlertManager.alertUser(title: StringConstants.generalErrorTitle, message: StringConstants.generalErrorMessage)
            return
        }
        guard let emailText = newEmailTextField.text else {
            AlertManager.alertUser(title: StringConstants.generalErrorTitle, message: StringConstants.generalErrorMessage)
            return
        }

        AccountManager.updateEmail(password: passwordText, email: emailText)
    }

    @objc private func closeChangeEmail() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension ChangeEmailViewController: UITextFieldDelegate {
    // Works so such that pressing the return button in the password text field makes the e-mail text field the first responder and pressing the return button in the email text field submits the information in the two text field for changing the user's e-mail
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case newEmailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            changeEmail()
        default:
            return true
        }

        return true
    }
}
