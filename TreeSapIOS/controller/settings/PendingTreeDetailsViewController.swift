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
import ImageSlideshow

class PendingTreeDetailsViewController: UIViewController {
    // MARK: - Properties
    var displayedTree: Tree?
    
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var dbhLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var notesContainerStackView: UIStackView!
    @IBOutlet weak var viewNotesButton: UIButton!
    @IBOutlet weak var hideNotesButton: UIButton!
    @IBOutlet weak var notesStackView: UIStackView!
    @IBOutlet weak var photosContainerStackView: UIStackView!
    @IBOutlet weak var viewPhotosButton: UIButton!
    @IBOutlet weak var hidePhotosButton: UIButton!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
        // Set up notes
        hideNotesButton.isHidden = true
        notesContainerStackView.isHidden = true
        if displayedTree!.notes == [] {
            viewNotesButton.isHidden = true
        }
        for note in displayedTree!.notes {
            let label = UILabel()
            label.text = note
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            notesStackView.addArrangedSubview(label)
        }
        // Set up photos
        hidePhotosButton.isHidden = true
        photosContainerStackView.isHidden = true
        if displayedTree!.images == [] {
            viewPhotosButton.isHidden = true
        }
        setupImages()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTreeSuccess), name: NSNotification.Name("updateTreeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTreeFailure), name: NSNotification.Name("updateTreeFailure"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTreeSuccess), name: NSNotification.Name("deleteTreeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTreeFailure), name: NSNotification.Name("deleteTreeFailure"), object: nil)
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
        if !images.isEmpty {
            var imageSources = [ImageSource]()
            for image in images {
                imageSources.append(ImageSource(image: image))
            }
            imageSlideshow.setImageInputs(imageSources)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapSlideshow))
            imageSlideshow.addGestureRecognizer(gestureRecognizer)
        } else {
            imageSlideshow.isHidden = true
        }
    }
    
    @objc private func didTapSlideshow() {
        imageSlideshow.presentFullScreenController(from: self)
    }
    
    /// Dismisses the loading alert, and then alerts the user that the tree was successfully accepted.
    @objc private func updateTreeSuccess() {
        dismiss(animated: true) {
            let alert = UIAlertController(title: "Success!", message: "The tree has been updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.closePendingTreeDetails() }))
            self.present(alert, animated: true)
        }
    }
    
    /// Dismisses the loading alert, and then alerts the user that there was an error while trying to update the tree.
    @objc private func updateTreeFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: "Error updating tree", message: "An error occurred while trying to update the tree. Please try again.")
        }
    }
    
    /// Dismisses the loading alert, and then alerts the user that the tree was successfully removed.
    @objc private func deleteTreeSuccess() {
        dismiss(animated: true) {
            let alert = UIAlertController(title: "Success!", message: "The tree has been removed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.closePendingTreeDetails() }))
            self.present(alert, animated: true)
        }
    }
    
    /// Dismisses the loading alert, and then alerts the user that there was an error while trying to remove the tree.
    @objc private func deleteTreeFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: "Error removing tree", message: "An error occurred while trying to remove the tree. Please try again.")
        }
    }
    
    /// Closes the pending tree details screen.
    private func closePendingTreeDetails() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Accept tree?", message: "This tree will be added to the online database for everyone to see.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            DatabaseManager.moveDataToAccepted(documentID: self.displayedTree!.documentID!)
            let loadingAlert = UIAlertController(title: "Please wait...", message: nil, preferredStyle: .alert)
            self.present(loadingAlert, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reject tree?", message: "This tree will be removed from the database.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            DatabaseManager.removeDataFromPending(documentID: self.displayedTree!.documentID!)
            let loadingAlert = UIAlertController(title: "Please wait...", message: nil, preferredStyle: .alert)
            self.present(loadingAlert, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @IBAction func viewNotesButtonPressed(_ sender: UIButton) {
        viewNotesButton.isHidden = true
        hideNotesButton.isHidden = false
        viewPhotosButton.isHidden = false
        hidePhotosButton.isHidden = true
        self.notesContainerStackView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.notesContainerStackView.isHidden = false
            self.notesContainerStackView.layer.opacity = 1
            self.photosContainerStackView.isHidden = true
            self.photosContainerStackView.layer.opacity = 0
        }
    }
    
    @IBAction func hideNotesButtonPressed(_ sender: UIButton) {
        viewNotesButton.isHidden = false
        hideNotesButton.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.notesContainerStackView.isHidden = true
            self.notesContainerStackView.layer.opacity = 0
        }
    }
    
    @IBAction func viewPhotosButtonPressed(_ sender: UIButton) {
        viewPhotosButton.isHidden = true
        hidePhotosButton.isHidden = false
        viewNotesButton.isHidden = false
        hideNotesButton.isHidden = true
        self.photosContainerStackView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.photosContainerStackView.isHidden = false
            self.photosContainerStackView.layer.opacity = 1
            self.notesContainerStackView.isHidden = true
            self.notesContainerStackView.layer.opacity = 0
        }
    }
    
    @IBAction func hidePhotosButtonPressed(_ sender: UIButton) {
        viewPhotosButton.isHidden = false
        hidePhotosButton.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.photosContainerStackView.isHidden = true
            self.photosContainerStackView.layer.opacity = 0
        }
    }
}
