//
//  CoordinatesViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
// Used https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift as a reference.
//

import MapKit
import UIKit

class CoordinatesViewController: NotificaionBadgeViewController {
    // MARK: - Properties

    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNotificationBadge()
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
            AlertManager.alertUser(title: StringConstants.invalidCoordinatesTitle, message: StringConstants.invalidCoordinatesMessage)
            return
        }
        // Check that the latitude and longitude values are in the correct ranges
        if latitude! < -90.0 || latitude! > 90.0 || longitude! < -180.0 || longitude! > 180.0 {
            AlertManager.alertUser(title: StringConstants.coordinatesOutOfRangeTitle, message: StringConstants.coordinatesOutOfRangeMessage)
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
            AlertManager.alertUser(title: StringConstants.noTreesFoundByCoordinatesTitle, message: StringConstants.noTreesFoundByCoordinatesMessage)
            return
        }

        let pages = TreeDetailPageViewController(tree: treeToDisplay!)
        navigationController?.pushViewController(pages, animated: true)
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

extension CoordinatesViewController: UITextFieldDelegate {
    /// Ensures that text fields on this view controller only allow numbers, dashes, and dots.
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "-.0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    /// Function that is called when the return key is pressed on the keyboard. Sets the next text field to be first responder or handles submit events appropriately.
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
}
