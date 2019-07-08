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

    ///Updates the password
    @IBAction func changePasswordButtonPressed(_: UIButton) {
        updatePassword()
    }

    ///Sends a request to the account manager to change the user's password. Shows a loading notification while the database has not responded. If the text in the new password and confirm password text fields do not match, the user is alerted and no request is sent.
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

    ///Dismisses the loading notification and shows the user an incorrect password alert. Assumes that there is a loading notification and will likely have strange behavior if there is none.
    @objc private func onAuthenticationFailure(){
        dismiss(animated: true){
            AlertManager.alertUser(title: StringConstants.incorrectPasswordTitle, message: StringConstants.incorrectPasswordMessage)
        }
    }
    
    /**
     Dismisses the loading notification. If the notification this function takes indicates that there was an error in the password change, displays an appropriate alert. Otherwise, pops this view off of the navigation controller stack. Assumes that there is a loading notification and will likely have strange behavior if there is none.
     - Parameter notification: the notification received by this class that caused this function to be called
     */
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
    //Makes returning from any but the lowest text field cause the next lowest text field to become the first responder and returning from the lowest text field cause both the password to be updated and the keyboard to be dismmissed
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
