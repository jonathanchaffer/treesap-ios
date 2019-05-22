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
        let dataSets = appDelegate.getDataSets()
        mapView.delegate = self
        if #available(iOS 11.0, *) {
            mapView.register(TreeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
        for dataSet in dataSets {
            for tree in dataSet {
                mapView.addAnnotation(TreeAnnotation(tree: tree))
            }
        }
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
        // If authorized, set starting location to current location and show current location. Otherwise, use Hope College as a default.
        if (appDelegate.locationFeaturesEnabled && locationManager.location != nil) {
            centerMapOnLocation(location: locationManager.location!.coordinate)
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 1
        } else {
            centerMapOnLocation(location: CLLocationCoordinate2D(latitude: 42.787283, longitude: -86.103612))
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
