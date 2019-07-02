//
//  AddTreeOtherViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import SearchTextField
import UIKit

class AddTreeOtherViewController: AddTreeViewController {
    // MARK: - Properties

    @IBOutlet var commonNameTextField: SearchTextField!
    @IBOutlet var scientificNameTextField: SearchTextField!

    @IBOutlet var measurementStackView: UIStackView!
    @IBOutlet var dbhTextField: UITextField!
    @IBOutlet var circumferenceTextField: UITextField!
    @IBOutlet var measurement1StackView: UIStackView!
    @IBOutlet var dbh1TextField: UITextField!
    @IBOutlet var circumference1TextField: UITextField!
    @IBOutlet var measurement2StackView: UIStackView!
    @IBOutlet var dbh2TextField: UITextField!
    @IBOutlet var circumference2TextField: UITextField!
    @IBOutlet var measurement3StackView: UIStackView!
    @IBOutlet var dbh3TextField: UITextField!
    @IBOutlet var circumference3TextField: UITextField!

    @IBOutlet var metricSwitch: UISwitch!
    @IBOutlet var dbhLabels: [UILabel]!
    @IBOutlet var circumferenceLabels: [UILabel]!

    @IBOutlet var notesTextField: MultilineTextField!

    /// The number of additional measurements that are currently being shown.
    var visibleMeasurementsCount = 1

    var dbhTextFields = [UITextField]()
    var circumferenceTextFields = [UITextField]()
    var measurementStackViews = [UIStackView]()

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up auto-suggesting text fields
        commonNameTextField.delegate = self
        let commonNames = Array(TreeNames.nameMap.keys).sorted()
        commonNameTextField.filterStrings(commonNames)
        commonNameTextField.theme.font = .systemFont(ofSize: 14)
        commonNameTextField.theme.bgColor = UIColor.white
        commonNameTextField.itemSelectionHandler = { items, index in
            let item = items[index]
            self.commonNameTextField.text = item.title
            self.scientificNameTextField.text = TreeNames.nameMap[item.title]!
            self.dbhTextField.becomeFirstResponder()
        }
        scientificNameTextField.delegate = self
        let scientificNames = Array(TreeNames.nameMap.values).sorted()
        scientificNameTextField.filterStrings(scientificNames)
        scientificNameTextField.theme.font = .systemFont(ofSize: 14)
        scientificNameTextField.theme.bgColor = UIColor.white
        scientificNameTextField.itemSelectionHandler = { items, index in
            let item = items[index]
            self.scientificNameTextField.text = item.title
            for commonName in commonNames {
                if TreeNames.nameMap[commonName] == item.title {
                    self.commonNameTextField.text = commonName
                    break
                }
            }
            self.dbhTextField.becomeFirstResponder()
        }
        // Hide the keyboard when tapped outside
        hideKeyboardWhenTappedAround()
        // Set up array of DBH text fields
        dbhTextFields = [dbhTextField, dbh1TextField, dbh2TextField, dbh3TextField]
        // Set up array of circumference text fields
        circumferenceTextFields = [circumferenceTextField, circumference1TextField, circumference2TextField, circumference3TextField]
        // Set up array of measurement stack views
        measurementStackViews = [measurementStackView, measurement1StackView, measurement2StackView, measurement3StackView]
        // Set up text field targets
        for textField in dbhTextFields {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        for textField in circumferenceTextFields {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        // Hide the extra measurement stack views
        for i in 1 ..< measurementStackViews.count {
            measurementStackViews[i].isHidden = true
        }
        // Set the metric switch to off
        metricSwitch.isOn = false
    }

    // MARK: - Actions

    /// Shows an "Are you sure?" alert. When the user taps OK, calls broadcastSubmitTree.
    @IBAction func handleDoneButtonPressed(_: UIButton) {
        view.endEditing(true)
        let alert = UIAlertController(title: StringConstants.confirmSubmitTreeTitle, message: StringConstants.confirmSubmitTreeMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.confirmSubmitTreeSubmitAction, style: .default, handler: { _ in self.broadcastSubmitTree() }))
        present(alert, animated: true)
    }

    /// Shows an alert that explains what DBH means.
    @IBAction func dbhInfoButtonPressed(_: UIButton) {
        AlertManager.alertUser(title: StringConstants.dbhExplanationTitle, message: StringConstants.dbhExplanationWithCircumferenceMessage)
    }

    /// Shows an additional measurement stack view.
    @IBAction func addMeasurementButtonPressed(_: UIButton) {
        if visibleMeasurementsCount < measurementStackViews.count {
            visibleMeasurementsCount += 1
            let stackViewToShow = measurementStackViews[visibleMeasurementsCount - 1]
            stackViewToShow.layer.opacity = 0
            UIView.animate(withDuration: 0.3, animations: {
                stackViewToShow.isHidden = false
                stackViewToShow.layer.opacity = 1
            })
        } else {
            AlertManager.alertUser(title: StringConstants.maxTrunkMeasurementsTitle, message: StringConstants.maxTrunkMeasurementsMessage0 + String(measurementStackViews.count) + StringConstants.maxTrunkMeasurementsMessage1)
        }
    }

    /// Hides a measurement stack view and clears its text.
    @IBAction func removeMeasurementButtonPressed(_: UIButton) {
        if visibleMeasurementsCount > 1 {
            visibleMeasurementsCount -= 1
            let stackViewToHide = measurementStackViews[visibleMeasurementsCount]
            UIView.animate(withDuration: 0.3, animations: {
                stackViewToHide.layer.opacity = 0
                stackViewToHide.isHidden = true
                self.dbhTextFields[self.visibleMeasurementsCount].text = nil
                self.circumferenceTextFields[self.visibleMeasurementsCount].text = nil
            })
        } else {
            AlertManager.alertUser(title: StringConstants.minTrunkMeasurementsTitle, message: StringConstants.minTrunkMeasurementsMessage)
        }
    }

    @IBAction func toggleMetric(_ sender: UISwitch) {
        if sender.isOn {
            for label in dbhLabels {
                label.text = "DBH (cm)"
            }
            for label in circumferenceLabels {
                label.text = "Circumference (cm)"
            }
        } else {
            for label in dbhLabels {
                label.text = "DBH (in)"
            }
            for label in circumferenceLabels {
                label.text = "Circumference (in)"
            }
        }
    }

    @IBAction func broadcastBack(_: UIButton) {
        previousPage()
    }

    // MARK: - Private functions

    /// Tells the AddTreePageViewController to submit the tree.
    private func broadcastSubmitTree() {
        NotificationCenter.default.post(name: NSNotification.Name(StringConstants.submitTreeNotification), object: nil)
    }

    /// Function that is called when a text field's text changes.
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text!
        if dbhTextFields.contains(textField) {
            let i = dbhTextFields.firstIndex(of: textField)!
            updateCircumference(dbhText: currentText, circumferenceTextField: circumferenceTextFields[i])
        }
        if circumferenceTextFields.contains(textField) {
            let i = circumferenceTextFields.firstIndex(of: textField)!
            updateDBH(circumferenceText: currentText, dbhTextField: dbhTextFields[i])
        }
    }

    /// Converts a DBH string to circumference and updates the specified text field.
    private func updateCircumference(dbhText: String, circumferenceTextField: UITextField) {
        let dbh = Double(dbhText)
        if dbh != nil {
            circumferenceTextField.text = String(format: "%.4f", Double.pi * dbh!)
        } else {
            circumferenceTextField.text = nil
        }
    }

    /// Converts a circumference string to DBH and updates the specified text field.
    private func updateDBH(circumferenceText: String, dbhTextField: UITextField) {
        let circumference = Double(circumferenceText)
        if circumference != nil {
            dbhTextField.text = String(format: "%.4f", circumference! / Double.pi)
        } else {
            dbhTextField.text = nil
        }
    }
}

extension AddTreeOtherViewController: UITextFieldDelegate {
    /// Function that is called when the return key is pressed on the keyboard. Sets the next text field to be first responder or handles submit events appropriately.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case commonNameTextField:
            scientificNameTextField.becomeFirstResponder()
        case scientificNameTextField:
            dbhTextField.becomeFirstResponder()
        case dbhTextField:
            if !measurement1StackView.isHidden {
                dbh1TextField.becomeFirstResponder()
            } else {
                circumferenceTextField.becomeFirstResponder()
            }
        case circumferenceTextField:
            if !measurement1StackView.isHidden {
                circumference1TextField.becomeFirstResponder()
            } else {
                notesTextField.becomeFirstResponder()
            }
        case dbh1TextField:
            if !measurement2StackView.isHidden {
                dbh2TextField.becomeFirstResponder()
            } else {
                circumference1TextField.becomeFirstResponder()
            }
        case circumference1TextField:
            if !measurement2StackView.isHidden {
                circumference2TextField.becomeFirstResponder()
            } else {
                notesTextField.becomeFirstResponder()
            }
        case dbh2TextField:
            if !measurement3StackView.isHidden {
                dbh3TextField.becomeFirstResponder()
            } else {
                circumference2TextField.becomeFirstResponder()
            }
        case circumference2TextField:
            if !measurement3StackView.isHidden {
                circumference3TextField.becomeFirstResponder()
            } else {
                notesTextField.becomeFirstResponder()
            }
        case dbh3TextField:
            circumference3TextField.becomeFirstResponder()
        case circumference3TextField:
            notesTextField.becomeFirstResponder()
        default:
            return true
        }
        return true
    }

    /// Ensures that measurement text fields only allow numbers and dots.
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        if dbhTextFields.contains(textField) || circumferenceTextFields.contains(textField) {
            let allowedCharacters = CharacterSet(charactersIn: ".0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
