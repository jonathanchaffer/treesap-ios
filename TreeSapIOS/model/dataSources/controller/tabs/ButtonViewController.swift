//
//  IdentifyViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
import UIKit

class IdentifyViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var bigButton: UIButton!
    var buttonDefaultWidth: CGFloat?
    var buttonDefaultOrigin: CGPoint?
    let sizeMultiplier = 0.95

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the styling for the big button
        bigButton.layer.cornerRadius = 0.5 * bigButton.bounds.size.width
        buttonDefaultWidth = bigButton.frame.size.width
        buttonDefaultOrigin = bigButton.frame.origin
    }

    override func viewDidAppear(_: Bool) {
        // Check authorization status.
        LocationManager.checkLocationAuthorization()
    }

    override func viewDidLayoutSubviews() {
        // Update the big button's corner radius whenever the orientation changes.
        // Done asynchronously so it uses the reformatted width instead of the width of the button before it was resized.
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bigButton.layer.cornerRadius = 0.5 * self.bigButton.bounds.size.width
            self.buttonDefaultWidth = self.bigButton.frame.size.width
            self.buttonDefaultOrigin = self.bigButton.frame.origin
        }
    }

    // MARK: - Actions

    /**
     Function that gets called when the big button is pressed. Checks the location authorization status and enables/disables location features accordingly, then displays tree data for the tree closest to the user's location, if any, and alerts the user otherwise.
     */
    @IBAction func handleBigButtonPressed(_: UIButton) {
        // If authorized, get tree data. Otherwise, alert the user.
        if LocationManager.locationFeaturesEnabled, LocationManager.getCurrentLocation() != nil {
            // If tree data was found, display it. Otherwise, alert the user.
            let treeToDisplay = getTreeDataByGPS()
            if treeToDisplay != nil {
                let pages = TreeDetailPageViewController(tree: treeToDisplay!)
                navigationController?.pushViewController(pages, animated: true)
            } else {
                AlertManager.alertUser(title: "No trees found", message: "There were no trees found near your location. You can update the identification distance in Settings.")
            }
        } else {
            AlertManager.alertUser(title: "Location could not be accessed", message: "Please ensure that location services are enabled.")
        }
    }

    @IBAction func touchDown(_: UIButton) {
        pushDownButton()
    }

    @IBAction func touchUpInside(_: UIButton) {
        pushUpButton()
    }

    @IBAction func touchDragExit(_: UIButton) {
        pushUpButton()
    }

    // MARK: - Private functions

    /**
     - Returns: The nearest tree based on the user's current GPS location.
     */
    private func getTreeDataByGPS() -> Tree? {
        let location = LocationManager.getCurrentLocation()!.coordinate
        return TreeFinder.findTreeByLocation(location: location, dataSources: PreferencesManager.getActiveDataSources(), cutoffDistance: PreferencesManager.getCutoffDistance())
    }

    private func pushDownButton() {
        let newWidth = Double(buttonDefaultWidth!) * sizeMultiplier
        let offset = (Double(buttonDefaultWidth!) - newWidth) / 2.0
        UIView.animate(withDuration: 0.1, animations: {
            self.bigButton.frame = CGRect(
                x: Double(self.bigButton.frame.origin.x) + offset,
                y: Double(self.bigButton.frame.origin.y) + offset,
                width: newWidth,
                height: newWidth
            )
            self.bigButton.layer.cornerRadius = CGFloat(0.5 * newWidth)
        })
    }

    private func pushUpButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.bigButton.frame = CGRect(
                x: self.buttonDefaultOrigin!.x,
                y: self.buttonDefaultOrigin!.y,
                width: self.buttonDefaultWidth!,
                height: self.buttonDefaultWidth!
            )
            self.bigButton.layer.cornerRadius = CGFloat(0.5 * self.buttonDefaultWidth!)
        })
    }
}
