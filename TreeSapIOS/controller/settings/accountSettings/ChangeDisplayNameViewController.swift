//
//  ChangeDisplayNameViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and modified by Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class ChangeDisplayNameViewController: UIViewController {
    @IBOutlet var newDisplayNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up a gesture recognizer that hides the keyboard when a spot on the screen outside of the keyboard or a text field is tapped
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDisplayNameChangeAttempt), name: NSNotification.Name(StringConstants.displayNameUpdateAttemptNotification), object: nil)
        
        newDisplayNameTextField.delegate = self
    }

    ///Shows a loading alert and makes a request to the AccountManager class to set the display name to the name in the new display name text field
    private func updateDisplayName() {
        // Ensure connection
        if !NetworkManager.isConnected {
            AlertManager.alertUser(title: StringConstants.noConnectionTitle, message: StringConstants.noConnectionMessage)
            return
        }
        AlertManager.showLoadingAlert()
        AccountManager.setDisplayName(displayName: newDisplayNameTextField.text!)
    }

    /**
     Dismisses the loading notification. If the notification this function takes indicates that there was an error in the display name change, displays an appropriate alert. Othersiwse, pops this view off of the navigation controller stack. Has undefined behavior if the loading alert is not the most recently pushed alert.
     - Parameter notification: the notification received by this class that caused this function to be called
     */
    @objc private func onDisplayNameChangeAttempt(_ notification: Notification) {
        let errorInfo = notification.userInfo as! [String: Error]
        
        dismiss(animated: true) {
            if(errorInfo.isEmpty){
                self.navigationController?.popViewController(animated: true)
            }else{
                AlertManager.alertUser(title: StringConstants.setDisplayNameFailureTitle, message: StringConstants.setDisplayNameFailureMessage)
            }
        }
    }

    ///Calls the updateDisplayName function. does not use the UIButton it takes as a parameter
    @IBAction func changeDisplayNameButtonPressed(_: UIButton) {
        updateDisplayName()
    }
}

extension ChangeDisplayNameViewController: UITextFieldDelegate {
    //Makes it so that returning from the new display name text field causes the keyboard to be dismissed and the updateDisplayName function called
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newDisplayNameTextField {
            self.view.endEditing(true)
            updateDisplayName()
        }
        return true
    }
}
