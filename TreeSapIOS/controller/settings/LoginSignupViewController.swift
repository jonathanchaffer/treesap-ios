//
//  LoginSignupViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 6/12/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Firebase

class LoginSignupViewController: UIViewController {
	// MARK: - Properties
	@IBOutlet weak var loginStackView: UIStackView!
	@IBOutlet weak var loginEmailTextField: UITextField!
	@IBOutlet weak var loginPasswordTextField: UITextField!
	@IBOutlet weak var createAccountStackView: UIStackView!
	@IBOutlet weak var createAccountEmailTextField: UITextField!
	@IBOutlet weak var createAccountPasswordTextField: UITextField!
	@IBOutlet weak var createAccountConfirmTextField: UITextField!
	
	// MARK: - Overrides
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loginStackView.isHidden = false
		
		NotificationCenter.default.addObserver(self, selector: #selector(closeLoginSignup), name: NSNotification.Name("loggedIn"), object: nil)
	}
	
	// MARK: - Actions
	@IBAction func showCreateAccount(_ sender: UIButton) {
		loginStackView.isHidden = true
		createAccountStackView.isHidden = false
	}
	
	@IBAction func signUpButtonPressed(_ sender: UIButton) {
		if createAccountEmailTextField.text != nil && createAccountPasswordTextField.text != nil && createAccountConfirmTextField.text != nil {
			// Check for non-matching passwords
			if createAccountPasswordTextField.text! != createAccountConfirmTextField.text! {
				AlertManager.alertUser(title: "Passwords do not match", message: "Please ensure that you enter the same password in both password fields.")
				return
			}
			// Create the user
			AccountManager.createUser(email: createAccountEmailTextField.text!, password: createAccountPasswordTextField.text!)
		}
	}
	
	@IBAction func logInButtonPressed(_ sender: UIButton) {
		if loginEmailTextField.text != nil && loginPasswordTextField.text != nil {
			AccountManager.logIn(email: loginEmailTextField.text!, password: loginPasswordTextField.text!)
		}
	}
	
	@IBAction func cancelCreateAccount(_ sender: UIButton) {
		createAccountStackView.isHidden = true
		loginStackView.isHidden = false
	}
	
	@objc func closeLoginSignup() {
		navigationController?.popViewController(animated: true)
		dismiss(animated: true, completion: nil)
	}
}
