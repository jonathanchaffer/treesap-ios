//
//  FirstViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import MapKit

class ButtonViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var bigButton: UIButton!
    let locationManager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigButton.layer.cornerRadius = 150
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted, .denied:
                appDelegate.disableLocationFeatures()
                break
            case .authorizedWhenInUse, .authorizedAlways:
                appDelegate.enableLocationFeatures()
                break
            default:
                break
        }
    }
    
    func getTreeDataByGPS() -> Tree? {
        if appDelegate.locationFeaturesEnabled {
            let location = locationManager.location!.coordinate
            let dataSets = appDelegate.getDataSets()
            return TreeFinder.findTree(location: location, dataSets: dataSets)
        } else {
            return nil
        }
    }
    
    @IBAction func handleBigButtonPressed(_ sender: UIButton) {
        if let treeToDisplay = getTreeDataByGPS() {
            let pages = TreeDetailPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pages.displayedTree = treeToDisplay
            navigationController?.pushViewController(pages, animated: true)
        } else {
            print("Location not enabled")
        }
    }
    
}

