//
//  AddTreeOtherViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeOtherViewController: AddTreeViewController {
    // MARK: - Properties

    @IBOutlet var commonNameTextField: UITextField!
    @IBOutlet var scientificNameTextField: UITextField!
    @IBOutlet var dbhTextField: UITextField!
    @IBOutlet weak var dbhLabel: UILabel!
    @IBOutlet var circumferenceTextField: UITextField!
    @IBOutlet weak var circumferenceLabel: UILabel!
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        dbhTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        circumferenceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    // MARK: - Actions

    /// Shows an "Are you sure?"-type alert. When the user taps OK, calls broadcastSubmitTree.
    @IBAction func handleDoneButtonPressed(_: UIButton) {
        let alert = UIAlertController(title: "Submit tree for approval?", message: "Your tree will be added to the online tree database for everyone to see if it is approved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.broadcastSubmitTree() }))
        present(alert, animated: true)
    }
    
    @IBAction func dbhInfoButtonPressed(_ sender: UIButton) {
        AlertManager.alertUser(title: "What does DBH mean?", message: "DBH is an acronym for Diameter at Breast Height, with breast height being 4.5 feet above the ground. If you update this field, the circumference field will update automatically, and vice versa.")
    }
    

    @IBAction func broadcastBack(_: UIButton) {
        previousPage()
    }

    // MARK: - Private functions
    
    /// Tells the AddTreePageViewController to submit the tree.
    private func broadcastSubmitTree() {
        NotificationCenter.default.post(name: NSNotification.Name("submitTree"), object: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text!
        if textField.restorationIdentifier == "dbhTextField" {
            let dbh = Double(currentText)
            if dbh != nil {
                circumferenceTextField.text = String(format: "%.4f", Double.pi * dbh!)
            } else {
                circumferenceTextField.text = nil
            }
        }
        if textField.restorationIdentifier == "circumferenceTextField" {
            let circumference = Double(currentText)
            if circumference != nil {
                dbhTextField.text = String(format: "%.4f", circumference! / Double.pi)
            } else {
                dbhTextField.text = nil
            }
        }
    }
}
