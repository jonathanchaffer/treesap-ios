//
//  CoordinatesViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
import UIKit

class CoordinatesViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties

    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    // MARK: - Actions

    /// Calls handleCoordinates when the Get Tree Data button is pressed.
    @IBAction func handleCoordinatesButtonPressed(_: UIButton) {
        handleCoordinates()
    }

    // MARK: - Functions

    /// Displays tree information for the inputted coordinates or alerts the user if invalid coordinates were entered.
    private func handleCoordinates() {
        // Convert the inputs to Double. If the conversion failed, alert the user.
        let latitude = Double(latitudeTextField.text!)
        let longitude = Double(longitudeTextField.text!)

        // Check that latitude and longitude values exist
        if latitude == nil || longitude == nil {
            AlertManager.alertUser(title: "Invalid coordinates", message: "Please make sure that you input valid coordinates.")
            return
        }
        // Check that the latitude and longitude values are in the correct ranges
        if latitude! < -90.0 || latitude! > 90.0 || longitude! < -180.0 || longitude! > 180.0 {
            AlertManager.alertUser(title: "Coordinates outside of valid range", message: "The latitude must be between -90 and 90. The longitude must be between -180 and 180.")
            return
        }
        // Check for frog
        if latitude == 42.788211256535, longitude == -86.105942862237 {
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "frog"), animated: true)
            return
        }

        // If tree data was found, display it. Otherwise, alert the user.
        let treeToDisplay = getTreeDataByCoords(latitude: latitude!, longitude: longitude!)
        if treeToDisplay == nil {
            AlertManager.alertUser(title: "No trees found", message: "There were no trees found near that location. You can update the identification distance in Settings.")
            return
        }

        let pages = TreeDetailPageViewController(tree: treeToDisplay!)
        navigationController?.pushViewController(pages, animated: true)
    }

    // If the text field is the first/latitude text field, the second/longitude text field becomes first responder (so it becomes selected). If the text field is the second/longitude text field, then the handleCoordinates function is called. Otherwise, nothing happens.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case latitudeTextField:
            longitudeTextField.becomeFirstResponder()
        case longitudeTextField:
            handleCoordinates()
        default:
            return true
        }
        return true
    }

    /**
     - Returns: A Tree object that corresponds to the tree closest to and within the cutoff distance of the given location, or nil if no such tree was found.

     - Parameter latitude: The latitude value.
     - Parameter longitude: The longitude value.
     */
    private func getTreeDataByCoords(latitude: Double, longitude: Double) -> Tree? {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return TreeFinder.findTreeByLocation(location: location, dataSources: PreferencesManager.getActiveDataSources(), cutoffDistance: PreferencesManager.getCutoffDistance())
    }
}

// Extension that makes the text fields allow only numbers, dashes, and dots.
// https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift
extension CoordinatesViewController {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "-.0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
