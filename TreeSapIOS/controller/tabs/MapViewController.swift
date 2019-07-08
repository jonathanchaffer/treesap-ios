//
//  MapViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Used https://www.raywenderlich.com/548-mapkit-tutorial-getting-started as a reference.

import MapKit
import UIKit

class MapViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 200
    /// The location on which the map will be centered if the user's location is not provided
    let defaultLocation = CLLocationCoordinate2D(latitude: 42.78758, longitude: -86.108110) // These are the coordinates of Centennial Park (in Holland, Michigan)

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        // Set the tint color for the user location.
        mapView.tintColor = UIColor(named: "myTree")!

        // If iOS 11 or above is available, register the custom annotation view.
        if #available(iOS 11.0, *) {
            mapView.register(TreeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }

        // If location use is authorized, set starting location to current location. Otherwise, use the default location.
        if LocationManager.locationFeaturesEnabled, LocationManager.getCurrentLocation() != nil {
            centerMapOnLocation(location: LocationManager.getCurrentLocation()!.coordinate)
        } else {
            centerMapOnLocation(location: defaultLocation)
        }
    }

    // MARK: - Overrides

    override func viewDidAppear(_: Bool) {
        // Check authorization status.
        LocationManager.checkLocationAuthorization()
        // Update notification badge
        updateNotificationBadge()
    }

    override func viewWillAppear(_: Bool) {
        // Show or hide user location based on the option in Settings.
        if PreferencesManager.getShowingUserLocation() {
            mapView.showsUserLocation = true
        } else {
            mapView.showsUserLocation = false
        }

        // Add annotations to the map.
        for dataSource in PreferencesManager.getActiveDataSources() {
            for tree in dataSource.getTreeList() {
                let annotation = TreeAnnotation(tree: tree)
                mapView.addAnnotation(annotation)
            }
        }
    }

    override func viewWillDisappear(_: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }

    // MARK: - Private functions

    private func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    /// Function that gets called whenever the info button is pressed on a map callout.
    func mapView(_: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped _: UIControl) {
        let annotation = view.annotation as! TreeAnnotation

        // Display tree data
        let pages = TreeDetailPageViewController(tree: annotation.tree)
        navigationController?.pushViewController(pages, animated: true)
    }

    /// When an annotation view is selected, deactivates tree annotations surrounding it so that the surrounding annotations do not get in the way of the user interacting with the annotation callout.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //        This commented out code is for hiding nearby annotations when an annotation is tapped
        //        let annotation = view.annotation as! TreeAnnotation
        //        let annotationPoint = MKMapPoint(annotation.coordinate)
        //        let deactivationRegion = MKMapSize(width: 0.5, height: 0.5)
        //        let annotationSet = mapView.annotations(in: MKMapRect(origin: annotationPoint, size: MKMapSize.world))
        for nearbyAnnotation in mapView.annotations {
            let annotationView = mapView.view(for: nearbyAnnotation)
            if annotationView != nil {
                annotationView!.isUserInteractionEnabled = false
            }
        }
        view.isUserInteractionEnabled = true
    }

    /// When an annotation view is deselected, reactivates tree annotations surrounding it.
    func mapView(_ mapView: MKMapView, didDeselect _: MKAnnotationView) {
        for nearbyAnnotation in mapView.annotations {
            let annotationView = mapView.view(for: nearbyAnnotation)
            if annotationView != nil {
                annotationView!.isUserInteractionEnabled = true
            }
        }
    }
}
