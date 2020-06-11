//
//  AddTreeLocationViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeLocationViewController: AddTreeViewController {
    // MARK: - Properties

    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        latitudeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        longitudeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self

        // Hide the next button at first
        nextButton.isHidden = true
    }

    // MARK: - Actions

    @IBAction func broadcastNext(_: UIButton) {
        verifyCoordinates()
    }

    func verifyCoordinates() {
        // Convert the inputs to Double. If the conversion failed, alert the user.
        let latitude = Double(latitudeTextField.text!)
        let longitude = Double(longitudeTextField.text!)
        if latitude == nil || longitude == nil {
            AlertManager.alertUser(title: StringConstants.invalidCoordinatesTitle, message: StringConstants.invalidCoordinatesMessage)
            return
        }
        // Check that the latitude and longitude values are in the correct ranges. If they aren't, alert the user.
        if latitude! < -90.0 || latitude! > 90.0 || longitude! < -180.0 || longitude! > 180.0 {
            AlertManager.alertUser(title: StringConstants.coordinatesOutOfRangeTitle, message: StringConstants.coordinatesOutOfRangeMessage)
            return
        }
        // Go to the next page
        nextPage()
    }

    @IBAction func updateLocation(_: UIButton) {
        // Check location authorization
        LocationManager.checkLocationAuthorization()

        if LocationManager.locationFeaturesEnabled {
            // Set the text for the location labels
            latitudeTextField.text = String(Double((LocationManager.getCurrentLocation()?.coordinate.latitude)!))
            longitudeTextField.text = String(Double((LocationManager.getCurrentLocation()?.coordinate.longitude)!))
            nextButton.isHidden = false
        } else {
            AlertManager.alertUser(title: StringConstants.locationUnvailableTitle, message: StringConstants.locationUnvailableMessage)
        }
    }
}

extension AddTreeLocationViewController: UITextFieldDelegate {
    /// Makes it so that text fields allow only numbers, dashes, and dots.
    // https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "-.0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    /// Function that is called when a text field changes. Hides the next button if the latitude and longitude are not both valid Doubles.
    @objc private func textFieldDidChange(_: UITextField) {
        let latitude = Double(latitudeTextField.text!)
        let longitude = Double(longitudeTextField.text!)
        if latitude != nil, longitude != nil {
            nextButton.isHidden = false
        } else {
            nextButton.isHidden = true
        }
    }

    /// Defines the behavior of the return key in different text fields.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case latitudeTextField:
            longitudeTextField.becomeFirstResponder()
        case longitudeTextField:
            verifyCoordinates()
        default:
            return true
        }
        return true
    }
}
