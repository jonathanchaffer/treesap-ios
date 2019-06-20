//
//  PendingTreeDetailsViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class PendingTreeDetailsViewController: UIViewController {
    // MARK: - Properties
    var data: [String: Any]?
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set common name label
        let commonName = data!["commonName"] as? String
        if commonName != nil && commonName != "" {
            commonNameLabel.text = commonName!
        } else {
            commonNameLabel.text = "Common Name N/A"
        }
        // Set scientific name label
        let scientificName = data!["scientificName"] as? String
        if scientificName != nil && scientificName != "" {
            scientificNameLabel.text = scientificName
        } else {
            scientificNameLabel.text = "Scientific Name N/A"
        }
        // Set latitude and longitude labels
        let latitude = data!["latitude"] as! Double
        let longitude = data!["longitude"] as! Double
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
        // Set up map view
        let coordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude),
            latitudinalMeters: 100,
            longitudinalMeters: 100)
        mapView.setRegion(coordinateRegion, animated: true)
        // If iOS 11 or above is available, register the custom annotation view.
        if #available(iOS 11.0, *) {
            mapView.register(TreeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
        mapView.addAnnotation(TreeAnnotation(tree: Tree(id: nil, commonName: nil, scientificName: nil, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), native: nil, userID: nil)))
    }
    
    // MARK: - Actions
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        
    }
    

}
