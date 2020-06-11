//
//  LoginSignupViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 6/12/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Firebase
import UIKit

class LoginSignupViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var loginStackView: UIStackView!
    @IBOutlet var loginEmailTextField: UITextField!
    @IBOutlet var loginPasswordTextField: UITextField!
    @IBOutlet var createAccountStackView: UIStackView!
    @IBOutlet var createAccountEmailTextField: UITextField!
    @IBOutlet var createAccountDisplayNameTextField: UITextField!
    @IBOutlet var createAccountPasswordTextField: UITextField!
    @IBOutlet var createAccountConfirmTextField: UITextField!
    @IBOutlet var closeButton: UIBarButtonItem!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        createAccountEmailTextField.delegate = self
        createAccountDisplayNameTextField.delegate = self
        createAccountPasswordTextField.delegate = self
        createAccountConfirmTextField.delegate = self
        hideKeyboardWhenTappedAround()
        loginStackView.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(closeLoginSignup), name: NSNotification.Name(StringConstants.loggedInNotification), object: nil)
    }

    // MARK: - Actions

    @IBAction func showCreateAccount(_: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.loginStackView.isHidden = true
            self.createAccountStackView.isHidden = false
        }
    }

    @IBAction func cancelCreateAccount(_: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.loginStackView.isHidden = false
            self.createAccountStackView.isHidden = true
        }
    }

    @IBAction func signUpButtonPressed(_: UIButton) {
        signUp()
    }

    @IBAction func logInButtonPressed(_: UIButton) {
        logIn()
    }

    @IBAction func closeButtonPressed(_: UIBarButtonItem) {
        closeLoginSignup()
    }

    // MARK: - Functions

    @objc func closeLoginSignup() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    private func logIn() {
        // Ensure connection
        if !NetworkManager.isConnected {
            AlertManager.alertUser(title: StringConstants.noConnectionTitle, message: StringConstants.noConnectionMessage)
            return
        }
        if loginEmailTextField.text != nil, loginPasswordTextField.text != nil {
            AccountManager.logIn(email: loginEmailTextField.text!, password: loginPasswordTextField.text!)
        }
    }

    private func signUp() {
        // Ensure connection
        if !NetworkManager.isConnected {
            AlertManager.alertUser(title: StringConstants.noConnectionTitle, message: StringConstants.noConnectionMessage)
            return
        }
        if createAccountEmailTextField.text != nil, createAccountPasswordTextField.text != nil, createAccountConfirmTextField.text != nil {
            // Check for non-matching passwords
            if createAccountPasswordTextField.text! != createAccountConfirmTextField.text! {
                AlertManager.alertUser(title: StringConstants.unmatchingPasswordsTitle, message: StringConstants.unmatchingPasswordsMessage)
                return
            }
            // Create the user
            AccountManager.createUser(email: createAccountEmailTextField.text!, displayName: createAccountDisplayNameTextField.text!, password: createAccountPasswordTextField.text!)
        }
    }
}

extension LoginSignupViewController: UITextFieldDelegate {
    /// Function that is called when the return key is pressed on the keyboard. Sets the next text field to be first responder or handles submit events appropriately.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginEmailTextField:
            loginPasswordTextField.becomeFirstResponder()
        case loginPasswordTextField:
            logIn()
        case createAccountEmailTextField:
            createAccountDisplayNameTextField.becomeFirstResponder()
        case createAccountDisplayNameTextField:
            createAccountPasswordTextField.becomeFirstResponder()
        case createAccountPasswordTextField:
            createAccountConfirmTextField.becomeFirstResponder()
        case createAccountConfirmTextField:
            signUp()
        default:
            return true
        }
        return true
    }
}
