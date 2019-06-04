//
//  FirstViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
import UIKit

class ButtonViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var bigButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check authorization status.
        appDelegate.checkLocationAuthorization()
        
        // Set the styling for the big button
        bigButton.layer.cornerRadius = 0.5 * bigButton.bounds.size.width
    }

    override func viewDidLayoutSubviews() {
        // Update the big button's corner radius whenever the orientation changes.
        // Using the dispatch queue makes the text in the trailing closure execute after this method (i.e. viewDidLayoutSubviews) finishes so that the width of the button is the reformatted width instead of the width of the button before it is resized
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bigButton.layer.cornerRadius = 0.5 * self.bigButton.bounds.size.width
        }
    }

    // MARK: - Actions

    /**
     Function that gets called when the big button is pressed. Checks the location authorization status and enables/disables location features accordingly, then displays tree data for the tree closest to the user's location, if any, and alerts the user otherwise.
     */
    @IBAction func handleBigButtonPressed(_: UIButton) {
        // If authorized, get tree data. Otherwise, alert the user.
        if appDelegate.locationFeaturesEnabled, appDelegate.locationManager.location != nil {
            // If tree data was found, display it. Otherwise, alert the user.
            let treeToDisplay = getTreeDataByGPS()
            if treeToDisplay != nil {
                let pages = TreeDetailPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                pages.displayedTree = treeToDisplay
                navigationController?.pushViewController(pages, animated: true)
            } else {
                let alert = UIAlertController(title: "No trees found", message: "There were no trees found near your location. You can update the identification distance in Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Location could not be accessed", message: "Please make sure that location services are enabled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }

    // MARK: - Private methods

    /**
     - Returns: The nearest tree based on the user's current GPS location.
     */
    private func getTreeDataByGPS() -> Tree? {
        let location = appDelegate.locationManager.location!.coordinate
        return TreeFinder.findTreeByLocation(location: location, dataSources: appDelegate.getActiveDataSources(), cutoffDistance: appDelegate.accessCutoffDistance())
    }
}
