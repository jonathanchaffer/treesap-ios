//
//  AccountManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import Firebase

class AccountManager {
	
	static func isLoggedIn() -> Bool {
		return Auth.auth().currentUser != nil
	}
	
	static func getEmail() -> String? {
		return Auth.auth().currentUser?.email
	}
	
	/**
	Tries to create a user in Firebase. Alerts the user if it doesn't work.
	*/
	static func createUser(email: String, password: String) {
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			if let error = error {
				switch error._code {
				case AuthErrorCode.invalidEmail.rawValue:
					AlertManager.alertUser(title: "Invalid email", message: "Please ensure that you have entered a valid email address.")
				case AuthErrorCode.emailAlreadyInUse.rawValue:
					AlertManager.alertUser(title: "Email already in use", message: "An account has already been created with that email.")
				case AuthErrorCode.weakPassword.rawValue:
					AlertManager.alertUser(title: "Weak password", message: "Please ensure that your password contains at least 6 characters.")
				default:
					AlertManager.alertUser(title: "Error", message: "There was an error creating your account. Please try again.")
				}
			} else {
				NotificationCenter.default.post(name: NSNotification.Name("loggedIn"), object: nil)
			}
		}
	}
	
	static func logIn(email: String, password: String) {
		Auth.auth().signIn(withEmail: email, password: password) { user, error in
			if let error = error {
				switch error._code {
				case AuthErrorCode.wrongPassword.rawValue:
					AlertManager.alertUser(title: "Incorrect password", message: "The password you entered was incorrect. Please try again.")
				case AuthErrorCode.invalidEmail.rawValue:
					AlertManager.alertUser(title: "Invalid email", message: "The email you entered is invalid. Please try again.")
				default:
					AlertManager.alertUser(title: "Error", message: "There was an error logging into your account. Please try again.")
				}
			} else {
				NotificationCenter.default.post(name: NSNotification.Name("loggedIn"), object: nil)
			}
		}
	}
	
	static func logOut() -> Bool {
		do {
			try Auth.auth().signOut()
			return true
		} catch {
			return false
		}
	}
}
