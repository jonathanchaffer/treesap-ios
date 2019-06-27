//
//  SimpleDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import ImageSlideshow

class SimpleDisplayViewController: TreeDisplayViewController {
    // MARK: - Properties
    @IBOutlet var commonNameLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var treeIDStackView: UIStackView!
    @IBOutlet var treeIDLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var dbhStackView: UIStackView!
    @IBOutlet var dbhLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet weak var notesContainerStackView: UIStackView!
    @IBOutlet weak var viewNotesButton: UIButton!
    @IBOutlet weak var hideNotesButton: UIButton!
    @IBOutlet weak var notesStackView: UIStackView!
    @IBOutlet weak var photosContainerStackView: UIStackView!
    @IBOutlet weak var viewPhotosButton: UIButton!
    @IBOutlet weak var hidePhotosButton: UIButton!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set common name label
        if displayedTree!.commonName != nil {
            commonNameLabel.text = displayedTree!.commonName
        } else {
            commonNameLabel.text = "Common Name N/A"
        }
        commonNameLabel.accessibilityValue = "commonNameLabel"
        // Set scientific name label
        if displayedTree!.scientificName != nil {
            scientificNameLabel.text = displayedTree!.scientificName
        } else {
            scientificNameLabel.isHidden = true
        }
        // Set tree ID label
        if displayedTree!.id != nil {
            treeIDLabel.text = String(displayedTree!.id!)
        } else {
            treeIDStackView.isHidden = true
        }
        // Set latitude and longitude labels
        latitudeLabel.text = String(displayedTree!.location.latitude)
        longitudeLabel.text = String(displayedTree!.location.longitude)
        // Set DBH label
        if displayedTree!.dbhArray != [] {
            var dbhString = ""
            for i in 0 ..< displayedTree!.dbhArray.count - 1 {
                dbhString += String(displayedTree!.dbhArray[i]) + "\", "
            }
            dbhString += String(displayedTree!.dbhArray[displayedTree!.dbhArray.count - 1]) + "\""
            dbhLabel.text = dbhString
        } else {
            dbhStackView.isHidden = true
        }
        // Set background image
        if displayedTree!.commonName != nil, UIImage(named: displayedTree!.commonName!) != nil {
            backgroundImage.image = UIImage(named: displayedTree!.commonName!)
        }
        // Set up notes
        hideNotesButton.isHidden = true
        notesContainerStackView.isHidden = true
        if displayedTree!.notes.isEmpty {
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
        var numPhotos = 0
        for imageCategory in displayedTree!.images.keys {
            numPhotos += displayedTree!.images[imageCategory]!.count
        }
        if numPhotos == 0 {
            viewPhotosButton.isHidden = true
        }
        setupSlideshow()
    }
    
    private func setupSlideshow() {
        var imageSources = [ImageSource]()
        for imageCategory in displayedTree!.images.keys {
            for image in displayedTree!.images[imageCategory]! {
                imageSources.append(ImageSource(image: image))
            }
        }
        imageSlideshow.setImageInputs(imageSources)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapSlideshow))
        imageSlideshow.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func didTapSlideshow() {
        imageSlideshow.presentFullScreenController(from: self)
    }
    
    /// Shows notes.
    private func showNotes() {
        viewNotesButton.isHidden = true
        hideNotesButton.isHidden = false
        self.notesContainerStackView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.notesContainerStackView.isHidden = false
            self.notesContainerStackView.layer.opacity = 1
        }
    }
    
    /// Shows photos.
    private func showPhotos() {
        viewPhotosButton.isHidden = true
        hidePhotosButton.isHidden = false
        self.photosContainerStackView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.photosContainerStackView.isHidden = false
            self.photosContainerStackView.layer.opacity = 1
        }
    }
    
    /// Hides notes.
    private func hideNotes() {
        viewNotesButton.isHidden = false
        hideNotesButton.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.notesContainerStackView.isHidden = true
            self.notesContainerStackView.layer.opacity = 0
        }
    }
    
    /// Hides photos.
    private func hidePhotos() {
        viewPhotosButton.isHidden = false
        hidePhotosButton.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.photosContainerStackView.isHidden = true
            self.photosContainerStackView.layer.opacity = 0
        }
    }
    
    // MARK: - Actions
    @IBAction func dbhInfoButtonPressed(_ sender: UIButton) {
        AlertManager.alertUser(title: "What does DBH mean?", message: "DBH is an acronym for Diameter at Breast Height, where breast height is 4.5 feet above the ground. If multiple numbers are listed, it means that the tree branches below breast height.")
    }
    
    @IBAction func viewNotesButtonPressed(_ sender: UIButton) {
        if !photosContainerStackView.isHidden {
            hidePhotos()
        }
        showNotes()
    }
    
    @IBAction func hideNotesButtonPressed(_ sender: UIButton) {
        hideNotes()
    }
    
    @IBAction func viewPhotosButtonPressed(_ sender: UIButton) {
        if !notesContainerStackView.isHidden {
            hideNotes()
        }
        showPhotos()
    }
    
    @IBAction func hidePhotosButtonPressed(_ sender: UIButton) {
        hidePhotos()
    }
}
