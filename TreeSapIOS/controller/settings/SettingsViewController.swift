//
//  SettingsViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    // MARK: Properties

    @IBOutlet var locationToggleSwitch: UISwitch!
    @IBOutlet var cutoffDistanceTextField: UITextField!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        cutoffDistanceTextField.delegate = self

        // Set up gesture recognizer that will dismiss the keyboard when the user taps outside of it
        // Based on code from https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1 and https://www.bignerdranch.com/blog/hannibal-selector/#tl-dr
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopEditingText))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillAppear(_: Bool) {
        locationToggleSwitch.isOn = PreferencesManager.showingUserLocation
        cutoffDistanceTextField.text = String(PreferencesManager.cutoffDistance)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Actions

    @IBAction func closeSettings(_: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func toggleLocationOnMap(_: UISwitch) {
        PreferencesManager.toggleShowingUserLocation()
    }

    /// Makes text fields stop getting edited, dismissing the keyboard if they are being edited
    @objc func stopEditingText() {
        cutoffDistanceTextField.endEditing(true)
    }

    /**
     Updates the cutoff distance, which is how close a tree must be to location given by the coordinates used to find a tree in order to be found

     - Parameter sender: the UITextField that caused this function call
     */
    @IBAction func updateCutoffDistance(_: UITextField) {
        if let dist = Double(cutoffDistanceTextField.text!) {
            PreferencesManager.setCutoffDistance(dist)
        } else {
            let defaultCutoff: Double = PreferencesManager.defaultCutoffDistance
            PreferencesManager.setCutoffDistance(defaultCutoff)
            cutoffDistanceTextField.text = String(defaultCutoff)
            let alert = UIAlertController(title: "Invalid number", message: "Distance has been reset to " + String(defaultCutoff), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}

// Extension that makes the text fields allow only numbers and dots.
// https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift
extension SettingsViewController {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: ".0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    /// Causes the the keyboard to be dismissed upon pressing the enter button when the text field is selected
    func textFieldShouldReturn(_: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
