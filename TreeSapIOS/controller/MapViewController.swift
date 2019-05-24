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
        
        // Set attributes of the location manager.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        
        // Check authorization status.
        checkLocationAuthorization()
        
        // If location use is authorized, set starting location to current location. Otherwise, use Centennial Park (in Holland, Michigan) as a default.
        if (appDelegate.locationFeaturesEnabled && locationManager.location != nil) {
            centerMapOnLocation(location: locationManager.location!.coordinate)
        } else {
            centerMapOnLocation(location: CLLocationCoordinate2D(latitude: 42.787586, longitude: -86.108110))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check authorization status.
        checkLocationAuthorization()
        
        // Show or hide user location based on the option in Settings.
        if (appDelegate.showingUserLocation) {
            mapView.showsUserLocation = true
        } else {
            mapView.showsUserLocation = false
        }
        
        // Add annotations to the map.
        mapView.removeAnnotations(mapView.annotations)
        let dataSources = appDelegate.getActiveDataSources()
        for dataSource in dataSources {
            for tree in dataSource.getTreeList() {
                mapView.addAnnotation(TreeAnnotation(tree: tree))
            }
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
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            appDelegate.disableLocationFeatures()
        case .authorizedWhenInUse, .authorizedAlways:
            appDelegate.enableLocationFeatures()
        default:
            return
        }
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
