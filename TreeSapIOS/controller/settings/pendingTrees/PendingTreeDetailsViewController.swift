//
//  PendingTreeDetailsViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Firebase
import ImageSlideshow
import MapKit
import UIKit

class PendingTreeDetailsViewController: UIViewController {
    // MARK: - Properties

    var displayedTree: Tree?

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var commonNameLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var dbhLabel: UILabel!
    @IBOutlet var notesStackView: UIStackView!
    @IBOutlet var noPhotosLabel: UILabel!
    @IBOutlet var imageSlideshow: ImageSlideshow!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupPhotos()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataSuccess), name: NSNotification.Name(StringConstants.updateDataSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataFailure), name: NSNotification.Name(StringConstants.updateDataFailureNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataSuccess), name: NSNotification.Name(StringConstants.deleteDataSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataFailure), name: NSNotification.Name(StringConstants.deleteDataFailureNotification), object: nil)
    }

    // MARK: - Private functions

    private func setupLabels() {
        let commonName = displayedTree!.commonName
        let scientificName = displayedTree!.scientificName
        let latitude = displayedTree!.location.latitude
        let longitude = displayedTree!.location.longitude
        let dbhArray = displayedTree!.dbhArray
        let notes = displayedTree!.notes

        // Set common name and scientific name labels
        if commonName != nil, commonName != "" {
            commonNameLabel.text = commonName!
        } else {
            commonNameLabel.text = "N/A"
        }
        if scientificName != nil, scientificName != "" {
            scientificNameLabel.text = scientificName!
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

        // Set up map
        let coordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            latitudinalMeters: 100,
            longitudinalMeters: 100
        )
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.register(TreeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotation(TreeAnnotation(tree: displayedTree!))
    }

    private func setupPhotos() {
        var imageSources = [ImageSource]()
        let imageMap = displayedTree!.images
        for imageCategory in imageMap.keys {
            for image in imageMap[imageCategory]! {
                imageSources.append(ImageSource(image: image))
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

    /// Dismisses the loading alert, and then alerts the user that the tree was successfully accepted.
    @objc private func updateDataSuccess() {
        dismiss(animated: true) {
            let alert = UIAlertController(title: StringConstants.treeUpdateSuccessTitle, message: StringConstants.treeUpdateSuccessMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default, handler: { _ in self.closePendingTreeDetails() }))
            self.present(alert, animated: true)
        }
    }

    /// Dismisses the loading alert, and then alerts the user that there was an error while trying to update the tree.
    @objc private func updateDataFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: StringConstants.treeUpdateFailureTitle, message: StringConstants.treeUpdateFailureMessage)
        }
    }

    /// Dismisses the loading alert, and then alerts the user that the tree was successfully removed.
    @objc private func deleteDataSuccess() {
        dismiss(animated: true) {
            let alert = UIAlertController(title: StringConstants.treeRemovalSuccessTitle, message: StringConstants.treeRemovalSuccessMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default, handler: { _ in self.closePendingTreeDetails() }))
            self.present(alert, animated: true)
        }
    }

    /// Dismisses the loading alert, and then alerts the user that there was an error while trying to remove the tree.
    @objc private func deleteDataFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: StringConstants.treeRemovalFailureTitle, message: StringConstants.treeRemovalFailureMessage)
        }
    }

    /// Closes the pending tree details screen.
    private func closePendingTreeDetails() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    /// Shows an alert asking the user whether they would like to send a message to the user.
    private func showAddMessageAlert(accepting: Bool) {
        let addMessageAlert = UIAlertController(title: StringConstants.addMessagePromptTitle, message: StringConstants.addMessagePromptMessage, preferredStyle: .alert)
        addMessageAlert.addAction(UIAlertAction(title: StringConstants.addMessagePromptAddMessageAction, style: .default) { _ in self.showAddMessageScreen(accepting: accepting) })
        var withoutMessageLabel: String?
        if accepting {
            withoutMessageLabel = StringConstants.addMessagePromptAcceptWithoutMessageAction
        } else {
            withoutMessageLabel = StringConstants.addMessagePromptRejectWithoutMessageAction
        }
        addMessageAlert.addAction(UIAlertAction(title: withoutMessageLabel!, style: .default) { _ in
            DatabaseManager.sendNotificationToUser(userID: self.displayedTree!.userID!, accepted: accepting, message: "", documentID: self.displayedTree!.documentID!)
            if accepting {
                DatabaseManager.acceptDocumentFromPending(documentID: self.displayedTree!.documentID!)
                AlertManager.showLoadingAlert()
            } else {
                DatabaseManager.rejectDocumentFromPending(documentID: self.displayedTree!.documentID!)
                AlertManager.showLoadingAlert()
            }
        })
        addMessageAlert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        present(addMessageAlert, animated: true)
    }

    /// Shows the add message screen.
    private func showAddMessageScreen(accepting: Bool) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addMessage") as! AddMessageViewController
        vc.accepting = accepting
        vc.documentID = displayedTree!.documentID
        vc.userID = displayedTree!.userID
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.tintColor = UIColor(named: "treesapGreen")!
        present(navigationController, animated: true)
    }

    // MARK: - Actions

    @IBAction func acceptButtonPressed(_: UIButton) {
        showAddMessageAlert(accepting: true)
    }

    @IBAction func rejectButtonPressed(_: UIButton) {
        showAddMessageAlert(accepting: false)
    }
}
