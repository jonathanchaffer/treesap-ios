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
    
    static func getDisplayName() -> String? {
        return Auth.auth().currentUser?.displayName
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
     - Parameter displayName: The inputted display name.
     - Parameter password: The inputted password.
     */
    static func createUser(email: String, displayName: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                switch error._code {
                case AuthErrorCode.invalidEmail.rawValue:
                    AlertManager.alertUser(title: StringConstants.invalidEmailTitle, message: StringConstants.invalidEmailMesage)
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    AlertManager.alertUser(title: StringConstants.emailAlreadyInUseTitle, message: StringConstants.emailAlreadyInUseMessage)
                case AuthErrorCode.weakPassword.rawValue:
                    AlertManager.alertUser(title: StringConstants.weakPasswordTitle, message: StringConstants.weakPasswordMessage)
                default:
                    AlertManager.alertUser(title: StringConstants.createAccountFailureTitle, message: StringConstants.createAccountFailureMessage)
                }
            } else {
                setDisplayName(displayName: displayName)
                NotificationCenter.default.post(name: NSNotification.Name(StringConstants.loggedInNotification), object: nil)
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
                    AlertManager.alertUser(title: StringConstants.incorrectPasswordTitle, message: StringConstants.incorrectPasswordMessage)
                case AuthErrorCode.invalidEmail.rawValue:
                    AlertManager.alertUser(title: StringConstants.invalidEmailTitle, message: StringConstants.invalidEmailMesage)
                case AuthErrorCode.userNotFound.rawValue:
                    AlertManager.alertUser(title: StringConstants.userNotFoundTitle, message: StringConstants.userNotFoundMessage)
                default:
                    AlertManager.alertUser(title: StringConstants.loginFailureTitle, message: StringConstants.loginFailureMessage)
                }
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(StringConstants.loggedInNotification), object: nil)
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
    
    /**
     Tries to set the display name of the current user. Shown an alert if there is an error. Returns without doing anything if no user is logged in.
     */
    static func setDisplayName(displayName: String) {
        guard let user = Auth.auth().currentUser else{
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        
        changeRequest.commitChanges() { error in
            if error != nil {
                AlertManager.alertUser(title: StringConstants.setDisplayNameFailureTitle, message: StringConstants.setDisplayNameFailureMessage)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(StringConstants.displayNameUpdatedNotification), object: nil)
            }
        }
    }
    
    static func updatePassword(oldPassword: String, newPassword: String) {
        let credential = EmailAuthProvider.credential(withEmail: getEmail()!, password: oldPassword)
        getUser()?.reauthenticate(with: credential) { result, error in
            
            if error != nil {
                AlertManager.alertUser(title: StringConstants.incorrectOldPasswordTitle, message: StringConstants.incorrectOldPasswordMessage)
                return
            }
            
            getUser()?.updatePassword(to: newPassword) { error in
                if let error = error {
                    switch error._code {
                    case AuthErrorCode.weakPassword.rawValue:
                        AlertManager.alertUser(title: StringConstants.weakPasswordTitle, message: StringConstants.weakPasswordMessage)
                    default:
                        AlertManager.alertUser(title: StringConstants.updatePasswordFailureTitle, message: StringConstants.updatePasswordFailureMessage)
                    }
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(StringConstants.passwordUpdatedNotification), object: nil)
                }
            }
            
        }
    }
    //TODO: use the StringContstancts class
    /**
     Changes the current user's e-mail to the specified e-mail. If there is no current user, nothing happens
     - Parameter email: the e-mail that the user's current e-mail is to be changed to
     */
    static func updateEmail(password: String, email: String){
        let credential = EmailAuthProvider.credential(withEmail: getEmail()!, password: password)
        getUser()?.reauthenticate(with: credential) { result, error in
            
            if error != nil {
                AlertManager.alertUser(title: StringConstants.incorrectPasswordTitle, message: StringConstants.incorrectPasswordMessage)
                return
            }
            
            getUser()?.updateEmail(to: email) { error in
                if let error = error{
                    switch error._code{
                    case AuthErrorCode.invalidEmail.rawValue:
                        AlertManager.alertUser(title: StringConstants.invalidEmailTitle, message: StringConstants.invalidEmailMesage)
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        AlertManager.alertUser(title: StringConstants.emailAlreadyInUseTitle, message: StringConstants.emailAlreadyInUseMessage)
                    case AuthErrorCode.requiresRecentLogin.rawValue:
                        AlertManager.alertUser(title: StringConstants.updateEmailFailureTitle, message: StringConstants.updateEmailFailureMessage)
                    default:
                        AlertManager.alertUser(title: StringConstants.updateEmailFailureTitle, message: StringConstants.updateEmailFailureMessage)
                    }
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(StringConstants.emailUpdatedNotification), object: nil)
                }
            }
            
        }
    }
    
    static func sendPasswordResetEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                AlertManager.alertUser(title: StringConstants.sendPasswordResetFailureTitle, message: StringConstants.sendPassowrdResetFailureMessage)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(StringConstants.passwordResetSentNotification), object: nil)
            }
        }
    }
}
