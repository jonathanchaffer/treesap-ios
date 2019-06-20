//
//  SettingsViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
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
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_: Bool) {
        locationToggleSwitch.isOn = PreferencesManager.getShowingUserLocation()
        cutoffDistanceTextField.text = String(PreferencesManager.getCutoffDistance())
    }

	/// Deselects a row when it is selected.
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
	
	/**
	Updates the cutoff distance, which is how close a tree must be to location given by the coordinates used to find a tree in order to be found
	
	- Parameter sender: the UITextField that caused this function call
	*/
	@IBAction func updateCutoffDistance(_: UITextField) {
		if let dist = Double(cutoffDistanceTextField.text!) {
			PreferencesManager.setCutoffDistance(dist)
		} else {
			let defaultCutoff: Double = PreferencesManager.getDefaultCutoffDistance()
			PreferencesManager.setCutoffDistance(defaultCutoff)
			cutoffDistanceTextField.text = String(defaultCutoff)
			let alert = UIAlertController(title: "Invalid number", message: "Distance has been reset to " + String(defaultCutoff), preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			present(alert, animated: true)
		}
	}
}

extension SettingsViewController: UITextFieldDelegate {
    /// Ensures that text fields on this view controller only allow numbers, dashes, and dots.
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "-.0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    /// Function that is called when the return key is pressed on the keyboard. Ends editing on the text field.
    func textFieldShouldReturn(_: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
