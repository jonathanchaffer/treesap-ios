//
//  SimpleDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import ImageSlideshow
import UIKit

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
    @IBOutlet var notesContainerStackView: UIStackView!
    @IBOutlet var notesButton: UIButton!
    @IBOutlet var notesStackView: UIStackView!
    @IBOutlet var photosContainerStackView: UIStackView!
    @IBOutlet var photosButton: UIButton!
    @IBOutlet var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var nearbyTreesButton: UIButton!
    
    var shouldHideNearbyTrees = false
    
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
        notesContainerStackView.isHidden = true
        if displayedTree!.notes.isEmpty {
            notesButton.isHidden = true
        }
        for note in displayedTree!.notes {
            let label = UILabel()
            label.text = note
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            notesStackView.addArrangedSubview(label)
        }
        // Set up photos
        photosContainerStackView.isHidden = true
        var numPhotos = 0
        for imageCategory in displayedTree!.images.keys {
            numPhotos += displayedTree!.images[imageCategory]!.count
        }
        if numPhotos == 0 {
            photosButton.isHidden = true
        }
        setupSlideshow()
        // Hide nearby trees button if necessary
        if shouldHideNearbyTrees {
            nearbyTreesButton.isHidden = true
        }
    }

    private func setupSlideshow() {
        var imageSources = [ImageSource]()
        for imageCategory in displayedTree!.images.keys {
            for image in displayedTree!.images[imageCategory]! {
                imageSources.append(ImageSource(image: image))
            }
        }
        imageSlideshow.setImageInputs(imageSources)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSlideshow))
        imageSlideshow.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func didTapSlideshow() {
        imageSlideshow.presentFullScreenController(from: self)
    }

    /// Shows notes.
    private func showNotes() {
        notesButton.setTitle("Hide Notes", for: .normal)
        notesContainerStackView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.notesContainerStackView.isHidden = false
            self.notesContainerStackView.layer.opacity = 1
        }
    }

    /// Shows photos.
    private func showPhotos() {
        photosButton.setTitle("Hide Photos", for: .normal)
        photosContainerStackView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.photosContainerStackView.isHidden = false
            self.photosContainerStackView.layer.opacity = 1
        }
    }

    /// Hides notes.
    private func hideNotes() {
        notesButton.setTitle("View Notes", for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.notesContainerStackView.isHidden = true
            self.notesContainerStackView.layer.opacity = 0
        }
    }

    /// Hides photos.
    private func hidePhotos() {
        photosButton.setTitle("View Photos", for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.photosContainerStackView.isHidden = true
            self.photosContainerStackView.layer.opacity = 0
        }
    }

    // MARK: - Actions

    @IBAction func dbhInfoButtonPressed(_: UIButton) {
        AlertManager.alertUser(title: StringConstants.dbhExplanationTitle, message: StringConstants.dbhExplanationWithMultipleMessage)
    }

    @IBAction func notesButtonPressed(_: UIButton) {
        if !photosContainerStackView.isHidden {
            hidePhotos()
        }
        if notesContainerStackView.isHidden {
            showNotes()
        } else {
            hideNotes()
        }
    }

    @IBAction func photosButtonPressed(_: UIButton) {
        if !notesContainerStackView.isHidden {
            hideNotes()
        }
        if photosContainerStackView.isHidden {
            showPhotos()
        } else {
            hidePhotos()
        }
    }
    
    @IBAction func nearbyTreesButtonPressed(_ sender: UIButton) {
        let nc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nearbyTrees") as! UINavigationController
        let vc = nc.viewControllers[0] as! NearbyTreesTableViewController
        vc.currentTree = displayedTree!
        self.present(nc, animated: true, completion: nil)
    }
}
