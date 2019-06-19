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
    ///The location on which the map will be centered if the user's location is not provided
    let defaultLocation: (Double, Double) = (42.78758, -86.108110)  //These are the coordinates of Centennial Park (in Holland, Michigan)

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
            centerMapOnLocation(location: CLLocationCoordinate2D(latitude: defaultLocation.0, longitude: defaultLocation.1))
        }
    }

    // MARK: - Overrides

    override func viewDidAppear(_: Bool) {
        // Check authorization status.
        LocationManager.checkLocationAuthorization()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }

    // MARK: - Private functions

    private func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - MKMapViewDelegate Protocol Functions
    
    //When this is finished, it should deactivate tree annotations surrounding a tree annotation that was tapped. This is so that the surrounding annotations do not get in the way of the user pressing the annotation callout
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        //This commented out code might be used later
//        let annotation = view.annotation as! TreeAnnotation
//        let annotationPoint = MKMapPoint(annotation.coordinate)
//        let deactivationRegion = MKMapSize(width: 0.5, height: 0.5)
//        let annotationSet = mapView.annotations(in: MKMapRect(origin: annotationPoint, size: MKMapSize.world))

        for nearbyAnnotation in mapView.annotations{
            let annotationView = mapView.view(for: nearbyAnnotation)
            if(annotationView != nil){
                annotationView!.isUserInteractionEnabled = false
            }
        }
        view.isUserInteractionEnabled = true
    }
    
    //When this is finished, it should reactivate tree annotations surrounding a tree annotation that was tapped.
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView){
        for nearbyAnnotation in mapView.annotations{
            let annotationView = mapView.view(for: nearbyAnnotation)
            if(annotationView != nil){
                annotationView!.isUserInteractionEnabled = true
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    // This function gets called whenever the info button is pressed on a map callout
    func mapView(_: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped _: UIControl) {
        
        let annotation = view.annotation as! TreeAnnotation

        // Display tree data
        let pages = TreeDetailPageViewController(tree: annotation.tree)
        navigationController?.pushViewController(pages, animated: true)
    }
}
