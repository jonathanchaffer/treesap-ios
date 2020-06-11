//
//  TreeAlertDetailViewController.swift
//  TreeSapIOS
//
//  Created by Mike Jipping on 6/9/20.
//  Copyright © 2020 Hope CS. All rights reserved.
//

import ImageSlideshow
import Firebase
import UIKit
import MapKit

class TreeAlertDetailsViewController: UIViewController {
    // MARK: - Properties

    var data: [String: Any]?
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var commonNameLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var treeIDLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    
    var docID: String = ""

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tree Alert"
        // Add a flag for user questions on a tree
        let locButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(locateTreefromAlert))
        let alertButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAlert))
        navigationItem.rightBarButtonItems = [alertButton, locButton]

        navigationController?.setToolbarHidden(true, animated: false)
        setupLabels()
    }

    // MARK: - Private functions

    private func setupLabels() {
        let commonName = data!["commonName"]! as! String
        let scientificName = data!["scientificName"]! as! String
        let latitude = data!["latitude"]! as! Double
        let longitude = data!["longitude"] as! Double
        let reason = data!["reason"] as! String
        let treeID = data!["treeID"] as! Int
        let timeStamp = data!["timestamp"]! as! Timestamp
        
        // Set title and subtitle
        if reason == "wrongIdentification" {
            titleLabel.text = "Wrong ID"
            subtitleLabel.text = "Claim: A(n) \(commonName) has been misidentified."
         } else if reason == "treeRemoved"{
             titleLabel.text = "Tree Removed"
             subtitleLabel.text = "Claim: A(n) \(commonName) has been added removed."
         } else {
             titleLabel.text = "Tree Replaced"
             subtitleLabel.text = "Claim: A(n) \(commonName) has been replaced with another tree."
         }
         titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
         subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        // Set common name and scientific name labels
        if commonName != "" {
            commonNameLabel.text = commonName
        } else {
            commonNameLabel.text = "N/A"
        }
        if scientificName != "" {
            scientificNameLabel.text = scientificName
        } else {
            scientificNameLabel.text = "N/A"
        }

        // Set latitude and longitude labels
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
        
        treeIDLabel.text = String(treeID)
        
        let myTimeInterval = TimeInterval(timeStamp.seconds)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        timestampLabel.text = time.description
    }
    
    @objc private func removeAlert() {
        let alert = UIAlertController(title: StringConstants.confirmDeleteAlertsTitle, message: StringConstants.confirmDeleteAlertsMessage, preferredStyle: .actionSheet)
         alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
         alert.addAction(UIAlertAction(title: StringConstants.confirmDeleteAlertsDeleteAction, style: .destructive) { _ in
            DatabaseManager.removeDocumentFromAlerts(documentID: self.docID)
            self.navigationController?.popViewController(animated: true)
         })

         present(alert, animated: true, completion: nil)
    }
    
    func openMapForPlace(treeName: String, latitude: Double, longitude: Double) {

        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = treeName
        mapItem.openInMaps(launchOptions: options)
    }
    
    @objc private func locateTreefromAlert() {
        let commonName = data!["commonName"]! as! String
        let latitude = data!["latitude"]! as! Double
        let longitude = data!["longitude"] as! Double
        openMapForPlace(treeName: commonName, latitude: latitude, longitude: longitude)
    }
    
}
