//
//  AddTreeLocationViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeLocationViewController: AddTreeViewController {
    // MARK: - Properties

    @IBOutlet var coordinatesStackView: UIStackView!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check location authorization
        appDelegate.checkLocationAuthorization()

        // Hide the location information and next button at first
        coordinatesStackView.isHidden = true
        nextButton.isHidden = true
    }

    // MARK: - Actions

    @IBAction func broadcastNext(_: UIButton) {
        nextPage()
    }

    @IBAction func updateLocation(_: UIButton) {
        if appDelegate.locationFeaturesEnabled {
            // Set the text for the location labels
            latitudeLabel.text = String(Double((appDelegate.locationManager.location?.coordinate.latitude)!))
            longitudeLabel.text = String(Double((appDelegate.locationManager.location?.coordinate.longitude)!))
            // Show the location information and next button
            coordinatesStackView.isHidden = false
            nextButton.isHidden = false
        } else {
            let alert = UIAlertController(title: "Location could not be accessed", message: "Please make sure that location services are enabled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
