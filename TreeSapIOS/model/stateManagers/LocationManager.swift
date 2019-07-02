//
//  LocationManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit

class LocationManager {
    // MARK: - Properties

    /// Indicates whether location features are enabled. NOTE: This is not a user preference; it is a flag that keeps track of whether the user has allowed access to device location.
    static var locationFeaturesEnabled = false

    /// CLLocationManager instance for the entire app.
    fileprivate static let locationManager = CLLocationManager()

    /// Delegate instance for the location manager.
    static let delegate = LocationManagerDelegate()

    // MARK: - Static functions

    /// Sets up the location manager.
    static func setup() {
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
    }

    /// - Returns: The current location.
    static func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }

    /// Checks the authorization status for user location, requesting authorization if needed.
    static func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    /// Function that is called when the location authorization status changes.
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Start updating location.
            LocationManager.locationFeaturesEnabled = true
            LocationManager.locationManager.startUpdatingLocation()
        case .restricted, .denied:
            // Stop updating location.
            LocationManager.locationFeaturesEnabled = false
            LocationManager.locationManager.stopUpdatingLocation()
        default:
            return
        }
    }
}
