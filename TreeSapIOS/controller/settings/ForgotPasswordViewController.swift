//
//  ForgotPasswordViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/24/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var forgotPasswordEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(passwordResetSent), name: NSNotification.Name("passwordResetSent"), object: nil)
    }
    
    private func sendPasswordResetEmail() {
        AccountManager.sendPasswordResetEmail(email: forgotPasswordEmailTextField.text!)
    }
    
    @objc private func passwordResetSent() {
        let alert = UIAlertController(title: "Password reset email sent", message: "A password reset email was successfully sent. Please check your inbox.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.closeForgotPassword() }))
        self.present(alert, animated: true)
    }
    
    private func closeForgotPassword() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPasswordResetButtonPressed(_ sender: UIButton) {
        sendPasswordResetEmail()
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == forgotPasswordEmailTextField {
            sendPasswordResetEmail()
        }
        return true
    }
}
