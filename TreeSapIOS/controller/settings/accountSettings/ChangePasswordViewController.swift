//
//  ChangePasswordViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var newPasswordConfirmTextField: UITextField!
    @IBOutlet var changePasswordButton: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up a gesture recognizer that hides the keyboard when a spot on the screen outside of the keyboard or a text field is tapped
        hideKeyboardWhenTappedAround()
        
        //Add observers for detecting notifications
        NotificationCenter.default.addObserver(self, selector: #selector(onAuthenticationFailure), name: NSNotification.Name(StringConstants.authenticationFailureNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPasswordUpdate), name: NSNotification.Name(StringConstants.passwordUpdateAttemptedNotification), object: nil)
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordConfirmTextField.delegate = self
    }

    @IBAction func changePasswordButtonPressed(_: UIButton) {
        updatePassword()
    }

    private func updatePassword() {
        AlertManager.showLoadingAlert()
        
        if newPasswordTextField.text! == newPasswordConfirmTextField.text! {
            AccountManager.updatePassword(oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!)
        } else {
            dismiss(animated: true) {
                AlertManager.alertUser(title: StringConstants.incorrectPasswordTitle, message: StringConstants.incorrectPasswordMessage)
            }
            return
        }
    }

    @objc private func onAuthenticationFailure(){
        dismiss(animated: true){
            AlertManager.alertUser(title: StringConstants.incorrectPasswordTitle, message: StringConstants.incorrectPasswordMessage)
        }
    }
    
    @objc private func onPasswordUpdate(_ notification: Notification) {
        let errorInfo = notification.userInfo as! [String: Error]
        
        dismiss(animated: true){
            if(errorInfo.isEmpty){
                self.navigationController?.popViewController(animated: true)
            }else{
                switch errorInfo["error"]!._code {
                case AuthErrorCode.weakPassword.rawValue:
                    AlertManager.alertUser(title: StringConstants.weakPasswordTitle, message: StringConstants.weakPasswordMessage)
                default:
                    AlertManager.alertUser(title: StringConstants.updatePasswordFailureTitle, message: StringConstants.updatePasswordFailureMessage)
                }
            }
        }
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
            self.view.endEditing(true)
            updatePassword()
        default:
            return true
        }
        return true
    }
}
