//
//  ChangeDisplayNameViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/24/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class ChangeDisplayNameViewController: UIViewController {
    @IBOutlet weak var newDisplayNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(closeChangeDisplayName), name: NSNotification.Name("displayNameUpdated"), object: nil)
    }
    
    private func updateDisplayName() {
        AccountManager.setDisplayName(displayName: newDisplayNameTextField.text!)
    }
    
    @objc private func closeChangeDisplayName() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeDisplayNameButtonPressed(_ sender: UIButton) {
        updateDisplayName()
    }
}

extension ChangeDisplayNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newDisplayNameTextField {
            updateDisplayName()
        }
        return true
    }
}
