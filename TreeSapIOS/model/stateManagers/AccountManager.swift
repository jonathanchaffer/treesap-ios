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
    
    static func getUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func getUserID() -> String? {
        return getUser()?.uid
    }
	
    /**
     Tries to create a user in Firebase with the given email and password. Alerts the user if it doesn't work.
     - Parameter email: The inputted email.
     - Parameter password: The inputted password.
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
	
    /**
     Tries to log in with the given email and password. Alerts the user if it doesn't work.
     - Parameter email: The inputted email.
     - Parameter password: The inputted password.
     */
	static func logIn(email: String, password: String) {
		Auth.auth().signIn(withEmail: email, password: password) { user, error in
			if let error = error {
				switch error._code {
				case AuthErrorCode.wrongPassword.rawValue:
					AlertManager.alertUser(title: "Incorrect password", message: "The password you entered was incorrect. Please try again.")
				case AuthErrorCode.invalidEmail.rawValue:
					AlertManager.alertUser(title: "Invalid email", message: "The email you entered is invalid. Please try again.")
                case AuthErrorCode.userNotFound.rawValue:
                    AlertManager.alertUser(title: "User not found", message: "A user with the email you entered was not found in our database. Please try again.")
				default:
					AlertManager.alertUser(title: "Error", message: "There was an error logging into your account. Please try again.")
				}
			} else {
				NotificationCenter.default.post(name: NSNotification.Name("loggedIn"), object: nil)
                DataManager.reloadFirebaseTreeData()
			}
		}
	}
    
    /**
     Tries to log out the current user.
     - Returns: true if it worked, false otherwise.
     */
	static func logOut() -> Bool {
		do {
			try Auth.auth().signOut()
            DataManager.reloadFirebaseTreeData()
			return true
		} catch {
			return false
		}
	}
}
