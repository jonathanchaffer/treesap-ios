//
//  SettingsViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    // MARK: - Properties

    @IBOutlet var locationToggleSwitch: UISwitch!
    @IBOutlet var cutoffDistanceTextField: UITextField!
    
    let numRowsPerSection = [2, 1, 2, 1]
    let sectionHeaders = [
        "Basic Settings",
        "Curator Settings",
        "Other Settings",
        nil
    ]
    let sectionFooters = [
        "Trees will be identified only if your coordinates are within this many meters from the tree.",
        "Edit, accept, or reject trees that have been submitted by users.",
        "Select which data sources will be displayed on the map and included in coordinate searches.",
        nil
    ]
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        cutoffDistanceTextField.delegate = self
        hideKeyboardWhenTappedAround()
        print(DatabaseManager.curators)
    }

    override func viewWillAppear(_: Bool) {
        locationToggleSwitch.isOn = PreferencesManager.getShowingUserLocation()
        cutoffDistanceTextField.text = String(PreferencesManager.getCutoffDistance())
        tableView.reloadData()
    }

	/// Deselects a row when it is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Sets the number of rows for each section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var myNumRowsPerSection = numRowsPerSection
        if !isCurator() {
            myNumRowsPerSection[1] = 0
        }
        return myNumRowsPerSection[section]
    }
    
    /// Sets the title of each section's header.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var mySectionHeaders = sectionHeaders
        if !isCurator() {
            mySectionHeaders[1] = nil
        }
        return mySectionHeaders[section]
    }
    
    /// Sets the title of each section's footer.
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var mySectionFooters = sectionFooters
        if !isCurator() {
            mySectionFooters[1] = nil
        }
        return mySectionFooters[section]
    }
    
    /// Sets the height of each section's header.
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isCurator() && section == 1 {
            return 0.01
        }
        return UITableView.automaticDimension
    }

    /// Sets the height of each section's footer.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !isCurator() && section == 1 {
            return 0.01
        }
        return UITableView.automaticDimension
    }
    
    // MARK: - Actions

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
    
    // MARK: - Private functions
    private func isCurator() -> Bool {
        return AccountManager.getUserID() != nil && DatabaseManager.curators.contains(AccountManager.getUserID()!)
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
