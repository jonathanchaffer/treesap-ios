//
//  NotificationDetailsViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import ImageSlideshow
import UIKit

class NotificationDetailsViewController: UIViewController {
    // MARK: - Properties

    var data: [String: Any]?
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var commonNameLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var dbhLabel: UILabel!
    @IBOutlet var notesStackView: UIStackView!
    @IBOutlet var imageSlideshow: ImageSlideshow!
    @IBOutlet var noPhotosLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification"
        navigationController?.setToolbarHidden(true, animated: false)
        setupLabels()
        setupPhotos()
    }

    // MARK: - Private functions

    private func setupLabels() {
        let accepted = data!["accepted"]! as! Bool
        let comments = data!["message"]! as! String
        let treeData = data!["treeData"]! as! [String: Any]
        let commonName = treeData["commonName"]! as! String
        let scientificName = treeData["scientificName"]! as! String
        let latitude = treeData["latitude"]! as! Double
        let longitude = treeData["longitude"] as! Double
        let dbhArray = treeData["dbhArray"]! as! [Double]
        let notes = treeData["notes"] as! [String]

        // Set title and subtitle
        if accepted {
            titleLabel.text = "Tree Accepted"
            if commonName != "" {
                subtitleLabel.text = "Your \(commonName) has been added to the database."
            } else {
                subtitleLabel.text = "Your tree has been added to the database."
            }
        } else {
            titleLabel.text = "Tree Rejected"
            if commonName != "" {
                subtitleLabel.text = "Your \(commonName) was not added to the database."
            } else {
                subtitleLabel.text = "Your tree was not added to the database."
            }
        }

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

        // Set DBH label
        if dbhArray != [] {
            var dbhString = ""
            for i in 0 ..< dbhArray.count - 1 {
                dbhString += String(dbhArray[i]) + "\", "
            }
            dbhString += String(dbhArray[dbhArray.count - 1]) + "\""
            dbhLabel.text = dbhString
        } else {
            dbhLabel.text = "N/A"
        }

        // Set notes labels
        if !notes.isEmpty {
            for note in notes {
                let label = UILabel()
                label.text = note
                label.numberOfLines = 0
                notesStackView.addArrangedSubview(label)
            }
        } else {
            let label = UILabel()
            label.text = "N/A"
            notesStackView.addArrangedSubview(label)
        }

        // Set comments label
        if comments != "" {
            commentsLabel.text = comments
        } else {
            commentsLabel.text = "N/A"
        }
    }

    private func setupPhotos() {
        var imageSources = [ImageSource]()
        let treeData = data!["treeData"]! as! [String: Any]
        let imageMap = treeData["images"] as! [String: [String]]
        for imageCategory in imageMap.keys {
            for encodedImage in imageMap[imageCategory]! {
                if let image = DatabaseManager.convertBase64ToImage(encodedImage: encodedImage) {
                    imageSources.append(ImageSource(image: image))
                }
            }
        }
        if !imageSources.isEmpty {
            noPhotosLabel.isHidden = true
            imageSlideshow.setImageInputs(imageSources)
        } else {
            imageSlideshow.isHidden = true
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSlideshow))
        imageSlideshow.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func didTapSlideshow() {
        imageSlideshow.presentFullScreenController(from: self)
    }
}
