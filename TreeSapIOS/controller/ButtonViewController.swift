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
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var bigButton: UIButton!
    let locationManager = CLLocationManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		bigButton.layer.cornerRadius = 150
    }
    
    @IBAction func handleBigButtonPressed(_ sender: UIButton) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            self.getTreeData()
            break
        case .restricted, .denied:
            // disable location features
            break
        case .authorizedWhenInUse, .authorizedAlways:
            // enable location features
            self.getTreeData()
            break
        default:
            break
        }
    }
    
    func getTreeData() {
        let location = locationManager.location!.coordinate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dataSets = appDelegate.getDataSets()
        commonNameLabel.text = TreeFinder.findTree(location: location, dataSets: dataSets)!.commonName
    }
    
}

