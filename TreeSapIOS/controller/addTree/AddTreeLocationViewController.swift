//
//  AddTreeLocationViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeLocationViewController: AddTreeViewController, UITextFieldDelegate {
    // MARK: - Properties
    
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        latitudeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        longitudeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        // Hide the next button at first
        nextButton.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func broadcastNext(_: UIButton) {
        // Convert the inputs to Double. If the conversion failed, alert the user.
        let latitude = Double(latitudeTextField.text!)
        let longitude = Double(longitudeTextField.text!)
        
        // Check that latitude and longitude values exist
        if latitude == nil || longitude == nil {
            AlertManager.alertUser(title: "Invalid coordinates", message: "Please make sure that you input valid coordinates.")
            return
        }
        
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
            AlertManager.alertUser(title: "Location could not be accessed", message: "Please make sure that location services are enabled.")
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let latitude = Double(latitudeTextField.text!)
        let longitude = Double(longitudeTextField.text!)
        if latitude != nil && longitude != nil {
            nextButton.isHidden = false
        } else {
            nextButton.isHidden = true
        }
    }
}

// Extension that makes the text fields allow only numbers, dashes, and dots.
// https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift
extension AddTreeLocationViewController {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "-.0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
