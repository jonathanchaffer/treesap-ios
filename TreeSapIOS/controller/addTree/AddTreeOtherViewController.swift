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
    @IBOutlet var measurementStackView: UIStackView!
    @IBOutlet var dbhTextField: UITextField!
    @IBOutlet var circumferenceTextField: UITextField!
    
    var extraMeasurementsCount = 0
    // Extra DBH/circumference inputs
    @IBOutlet weak var measurement1StackView: UIStackView!
    @IBOutlet weak var dbh1TextField: UITextField!
    @IBOutlet weak var circumference1TextField: UITextField!
    @IBOutlet weak var measurement2StackView: UIStackView!
    @IBOutlet weak var dbh2TextField: UITextField!
    @IBOutlet weak var circumference2TextField: UITextField!
    @IBOutlet weak var measurement3StackView: UIStackView!
    @IBOutlet weak var dbh3TextField: UITextField!
    @IBOutlet weak var circumference3TextField: UITextField!
    
    var dbhTextFields = [UITextField]()
    var circumferenceTextFields = [UITextField]()
    var measurementStackViews = [UIStackView]()
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Set up array of DBH text fields
        dbhTextFields = [dbhTextField, dbh1TextField, dbh2TextField, dbh3TextField]
        // Set up array of circumference text fields
        circumferenceTextFields = [circumferenceTextField, circumference1TextField, circumference2TextField, circumference3TextField]
        // Set up array of measurement stack views
        measurementStackViews = [measurementStackView, measurement1StackView, measurement2StackView, measurement3StackView]
        // Set up text field targets
        for textField in dbhTextFields {
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        for textField in circumferenceTextFields {
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        // Hide the extra measurement stack views
        for i in 1 ..< measurementStackViews.count {
            measurementStackViews[i].isHidden = true
        }
    }

    // MARK: - Actions

    /// Shows an "Are you sure?" alert. When the user taps OK, calls broadcastSubmitTree.
    @IBAction func handleDoneButtonPressed(_: UIButton) {
        let alert = UIAlertController(title: "Submit tree for approval?", message: "Your tree will be added to the online tree database for everyone to see if it is approved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.broadcastSubmitTree() }))
        present(alert, animated: true)
    }
    
    @IBAction func dbhInfoButtonPressed(_ sender: UIButton) {
        AlertManager.alertUser(title: "What does DBH mean?", message: "DBH is an acronym for Diameter at Breast Height, where breast height is 4.5 feet above the ground. If you update this field, the circumference field will update automatically, and vice versa.")
    }
    
    /// Shows an additional measurement stack view.
    @IBAction func addMeasurementButtonPressed(_ sender: UIButton) {
        if extraMeasurementsCount < measurementStackViews.count - 1 {
            extraMeasurementsCount += 1
            measurementStackViews[extraMeasurementsCount].isHidden = false
        } else {
            AlertManager.alertUser(title: "Maximum number of trunk measurements reached", message: "You can only input up to \(measurementStackViews.count) trunk measurements.")
        }
    }
    
    /// Hides a measurement stack view.
    @IBAction func removeMeasurementButtonPressed(_ sender: UIButton) {
        if extraMeasurementsCount >= 1 {
            extraMeasurementsCount -= 1
            measurementStackViews[extraMeasurementsCount].isHidden = true
        } else {
            AlertManager.alertUser(title: "Minimum number of trunk measurements reached", message: "At least one trunk measurement is needed.")
        }
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
        if textField == dbhTextField {
            updateCircumference(dbhText: currentText, circumferenceTextField: circumferenceTextField)
        }
        if textField == circumferenceTextField {
            updateDBH(circumferenceText: currentText, dbhTextField: dbhTextField)
        }
    }
    
    private func updateCircumference(dbhText: String, circumferenceTextField: UITextField) {
        let dbh = Double(dbhText)
        if dbh != nil {
            circumferenceTextField.text = String(format: "%.4f", Double.pi * dbh!)
        } else {
            circumferenceTextField.text = nil
        }
    }
    
    private func updateDBH(circumferenceText: String, dbhTextField: UITextField) {
        let circumference = Double(circumferenceText)
        if circumference != nil {
            dbhTextField.text = String(format: "%.4f", circumference! / Double.pi)
        } else {
            dbhTextField.text = nil
        }
    }
}
