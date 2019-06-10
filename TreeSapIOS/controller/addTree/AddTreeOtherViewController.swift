//
//  AddTreeOtherViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeOtherViewController: AddTreeViewController {
    // MARK: - Properties
    
    @IBOutlet weak var commonNameTextField: UITextField!
    @IBOutlet weak var scientificNameTextField: UITextField!
    @IBOutlet weak var dbhTextField: UITextField!
    @IBOutlet weak var circumferenceTextField: UITextField!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    // MARK: - Actions
    
    @IBAction func handleDoneButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Submit tree for approval?", message: "Your tree will be added to the online tree database if it is approved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.submitTree()}))
        present(alert, animated: true)
    }
    
    @IBAction func broadcastBack(_ sender: UIButton) {
        previousPage()
    }
    
    // MARK: - Private methods
    
    private func submitTree() {
        let alert = UIAlertController(title: "Success!", message: "Your tree has been submitted for approval. While you wait, your tree will be available in the \"My Trees\" data set on your device.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in self.broadcastAddTreeDone()}))
        present(alert, animated: true)
    }
    
    private func broadcastAddTreeDone() {
        NotificationCenter.default.post(name: NSNotification.Name("addTreeDone"), object: nil)
    }
}

/**
 Extension that hides the keyboard when it is tapped outside. Simply add 'self.hideKeyboardWhenTappedAround()' to viewDidLoad to bring this extension into effect.
 */
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
