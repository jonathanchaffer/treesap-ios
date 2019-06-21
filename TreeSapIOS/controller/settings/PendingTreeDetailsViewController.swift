//
//  PendingTreeDetailsViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class PendingTreeDetailsViewController: UIViewController {
    // MARK: - Properties
    var displayedTree: Tree?
    
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var dbhLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
        setupImages()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTreeSuccess), name: NSNotification.Name("updateTreeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTreeFailure), name: NSNotification.Name("updateTreeFailure"), object: nil)
    }
    
    // MARK: - Private functions
    
    private func setupDetails() {
        // Set common name label
        let commonName = displayedTree!.commonName
        if commonName != nil && commonName != "" {
            commonNameLabel.text = commonName!
        } else {
            commonNameLabel.text = "Common Name N/A"
        }
        // Set scientific name label
        let scientificName = displayedTree!.scientificName
        if scientificName != nil && scientificName != "" {
            scientificNameLabel.text = scientificName
        } else {
            scientificNameLabel.text = "Scientific Name N/A"
        }
        // Set DBH label
        if displayedTree!.dbhArray != [] {
            var dbhString = ""
            for i in 0 ..< displayedTree!.dbhArray.count - 1 {
                dbhString += String(displayedTree!.dbhArray[i]) + "\", "
            }
            dbhString += String(displayedTree!.dbhArray[displayedTree!.dbhArray.count - 1]) + "\""
            dbhLabel.text = dbhString
        } else {
            dbhLabel.text = "N/A"
        }
        // Set latitude and longitude labels
        let latitude = displayedTree!.location.latitude
        let longitude = displayedTree!.location.longitude
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
        mapView.register(TreeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotation(TreeAnnotation(tree: displayedTree!))
    }
    
    private func setupImages() {
        let images = displayedTree!.images
        let imageWidth = imagesScrollView.frame.height - 40
        let leadingSpace = CGFloat(20)
        print(imageWidth)
        let gutterSpace = CGFloat(8)
        for i in 0 ..< images.count {
            let imageView = UIImageView()
            imageView.image = images[i]
            let x = imagesScrollView.bounds.origin.x + (imageWidth + gutterSpace) * CGFloat(i) + leadingSpace
            let y = imagesScrollView.bounds.origin.y
            imageView.contentMode = .scaleAspectFill
            imageView.frame = CGRect(x: x, y: y, width: imageWidth, height: imageWidth)
            imageView.isUserInteractionEnabled = true
            imagesScrollView.addSubview(imageView)
        }
        imagesScrollView.contentSize.width = (imageWidth + gutterSpace) * CGFloat(images.count) + (2 * leadingSpace) - gutterSpace
    }
    
    /// Dismisses the loading alert, and then alerts the user that the tree was successfully accepted.
    @objc private func updateTreeSuccess() {
        dismiss(animated: true) {
            let alert = UIAlertController(title: "Success!", message: "The tree has been updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.closePendingTreeDetails() }))
            self.present(alert, animated: true)
        }
    }
    
    /// Dismisses the loading alert, and then alerts the user that the tree was successfully accepted.
    @objc private func updateTreeFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: "Error updating tree", message: "An error occurred while trying to update the tree. Please try again.")
        }
    }
    
    /// Closes the pending tree details screen.
    private func closePendingTreeDetails() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        DatabaseManager.moveDataToAccepted(documentID: displayedTree!.documentID!)
        // Display a "Please Wait" alert while it's trying to upload
        let loadingAlert = UIAlertController(title: "Please wait...", message: nil, preferredStyle: .alert)
        present(loadingAlert, animated: true)
    }
}
