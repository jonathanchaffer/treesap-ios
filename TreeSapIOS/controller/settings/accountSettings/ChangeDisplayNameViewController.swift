//
//  ChangeDisplayNameViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
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

    private func updateDisplayName() {
        AlertManager.showLoadingAlert()
        AccountManager.setDisplayName(displayName: newDisplayNameTextField.text!)
    }

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

    @IBAction func changeDisplayNameButtonPressed(_: UIButton) {
        updateDisplayName()
    }
}

extension ChangeDisplayNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newDisplayNameTextField {
            self.view.endEditing(true)
            updateDisplayName()
        }
        return true
    }
}
