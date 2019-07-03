//
//  ChangeEmailViewController.swift
//  TreeSapIOS
//
//  Created by Research on 7/1/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Firebase

class ChangeEmailViewController: UIViewController {
    @IBOutlet var passwordEntry: UITextField!
    @IBOutlet var emailEntry: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Sets up gesture recognizer so that keyboard is dismissed when the user taps outside of the keyboard and all text fields
        hideKeyboardWhenTappedAround()

        //Add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(onFailedAuthentication), name: NSNotification.Name(StringConstants.authenticationFailureNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resolveEmailUpdate), name: NSNotification.Name(StringConstants.emailUpdateAttemptNotification), object: nil)

        passwordEntry.delegate = self
        emailEntry.delegate = self
    }

    @IBAction func changeEmailButtonPress(_: UIButton) {
        changeEmail()
    }

    /// If the password entered in the password entry text field is correct, this function requests that Firebase change the current user's e-mail to the e-mail specified in the test field or, if there is no current user, does nothing. Otherwise, the user is informed that the entered password was not correct.
    func changeEmail() {
        guard let passwordText = passwordEntry.text else {
            AlertManager.alertUser(title: StringConstants.incorrectPasswordTitle, message: StringConstants.incorrectPasswordMessage)
            return
        }
        guard let emailText = emailEntry.text else {
            AlertManager.alertUser(title: StringConstants.incorrectEmailTitle, message: StringConstants.incorrectEmailMessage)
            return
        }
        
        AccountManager.updateEmail(password: passwordText, email: emailText)
        
        AlertManager.showLoadingAlert()
    }

    @objc private func onFailedAuthentication(){
        dismiss(animated: true) {
            AlertManager.alertUser(title: StringConstants.incorrectPasswordTitle, message: StringConstants.incorrectPasswordMessage)
        }
    }
    
    @objc private func resolveEmailUpdate(_ notification: Notification) {
        guard let errorInfo = notification.userInfo as? [String: Error] else{   //TODO: change this
            return
        }
        
        dismiss(animated: true) {
            if(errorInfo.isEmpty){
                self.navigationController?.popViewController(animated: true)
            }else{
                switch errorInfo["error"]!._code {
                case AuthErrorCode.invalidEmail.rawValue:
                    AlertManager.alertUser(title: StringConstants.invalidEmailTitle, message: StringConstants.invalidEmailMesage)
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    AlertManager.alertUser(title: StringConstants.emailAlreadyInUseTitle, message: StringConstants.emailAlreadyInUseMessage)
                case AuthErrorCode.requiresRecentLogin.rawValue:
                    AlertManager.alertUser(title: StringConstants.updateEmailFailureTitle, message: StringConstants.updateEmailFailureMessage)
                default:
                    AlertManager.alertUser(title: StringConstants.updateEmailFailureTitle, message: StringConstants.updateEmailFailureMessage)
                }
            }
        }
        
    }
}

extension ChangeEmailViewController: UITextFieldDelegate {
    // Works so such that pressing the return button in the password text field makes the e-mail text field the first responder and pressing the return button in the email text field submits the information in the two text field for changing the user's e-mail
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordEntry:
            emailEntry.becomeFirstResponder()
        case emailEntry:
            self.view.endEditing(true)
            changeEmail()
        default:
            return true
        }

        return true
    }
}
