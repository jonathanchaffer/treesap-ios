//
//  MapViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  https://www.raywenderlich.com/548-mapkit-tutorial-getting-started

import UIKit
import MapKit


class MapViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Set the tint color for the user location.
        mapView.tintColor = UIColor(red: 0.30, green: 0.66, blue: 0.28, alpha: 1)
        // If iOS 11 or above is available, register the custom annotation view.
        if #available(iOS 11.0, *) {
            mapView.register(TreeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
        // Add annotations to the map.
        let dataSets = appDelegate.getDataSets()
        for dataSet in dataSets {
            for tree in dataSet {
                mapView.addAnnotation(TreeAnnotation(tree: tree))
            }
        }
        // If location use is authorized, set starting location to current location. Otherwise, use Hope College as a default.
        if (appDelegate.locationFeaturesEnabled && locationManager.location != nil) {
            centerMapOnLocation(location: locationManager.location!.coordinate)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 1
        } else {
            centerMapOnLocation(location: CLLocationCoordinate2D(latitude: 42.787283, longitude: -86.103612))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        // Show or hide user location based on the option in Settings.
        if (appDelegate.showingUserLocation) {
            mapView.showsUserLocation = true
        } else {
            mapView.showsUserLocation = false
        }
    }
    
    // MARK: Private methods
    private func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func displayTreeData(treeToDisplay: Tree) {
        let pages = TreeDetailPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pages.displayedTree = treeToDisplay
        navigationController?.pushViewController(pages, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    // This function gets called whenever the info button is pressed on a map callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! TreeAnnotation
        self.displayTreeData(treeToDisplay: annotation.tree)
    }
}
