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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var locationToggleSwitch: UISwitch!
    @IBOutlet weak var cutoffDistanceTextField: UITextField!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        cutoffDistanceTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationToggleSwitch.isOn = appDelegate.showingUserLocation
        cutoffDistanceTextField.text = String(appDelegate.cutoffDistance)
    }
    
    // MARK: Actions
    @IBAction func closeSettings(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleLocationOnMap(_ sender: UISwitch) {
        appDelegate.toggleShowingUserLocation()
    }
    
    @IBAction func updateCutoffDistance(_ sender: UITextField) {
        if let dist = Double(cutoffDistanceTextField.text!) {
            appDelegate.cutoffDistance = dist
        } else {
            appDelegate.cutoffDistance = 100.0
            cutoffDistanceTextField.text = "100.0"
            let alert = UIAlertController(title: "Invalid number", message: "Distance has been reset to 100.0.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

// Extension that makes the text fields allow only numbers and dots.
// https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift
extension SettingsViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:".0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
