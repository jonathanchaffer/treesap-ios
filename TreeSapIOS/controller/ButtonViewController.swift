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
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 1
	}
	
	override func viewWillAppear(_ animated: Bool) {
		locationManager.startUpdatingLocation()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		locationManager.stopUpdatingLocation()
	}
	
	// MARK: Actions
	@IBAction func handleBigButtonPressed(_ sender: UIButton) {
		// Check authorization status.
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
		
		// If authorized, get tree data. Otherwise, alert the user.
		if (appDelegate.locationFeaturesEnabled && locationManager.location != nil) {
			// If tree data was found, display it. Otherwise, alert the user.
			let treeToDisplay = self.getTreeDataByGPS()
			if (treeToDisplay != nil) {
				let pages = TreeDetailPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
				pages.displayedTree = treeToDisplay
				navigationController?.pushViewController(pages, animated: true)
			} else {
				let alert = UIAlertController(title: "No trees found", message: "There were no trees found near your location.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: true)
			}
		} else {
			let alert = UIAlertController(title: "Location could not be accessed", message: "Please make sure that location services are enabled.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	// MARK: Private methods
	private func getTreeDataByGPS() -> Tree? {
		let location = locationManager.location!.coordinate
		let dataSets = appDelegate.getDataSets()
		return TreeFinder.findTree(location: location, dataSets: dataSets)
	}
}

extension ButtonViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Updated location")
	}
}
