//
//  AddTreeLeafViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import ImageSlideshow
import UIKit

class AddTreeLeafViewController: AddTreePhotoViewController {
    // MARK: - Properties

    @IBOutlet var imageSlideshow: ImageSlideshow!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var clearPhotosButton: UIButton!
    @IBOutlet var addPhotoButton: UIButton!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        updateImages()
    }

    override func updateImages() {
        super.updateImages(imageSlideshow: imageSlideshow, nextButton: nextButton, skipButton: skipButton, clearPhotosButton: clearPhotosButton, addPhotoButton: addPhotoButton)
    }

    // MARK: - Actions

    @IBAction func broadcastNext(_: UIButton) {
        nextPage()
    }

    @IBAction func broadcastSkip(_: UIButton) {
        nextPage()
    }

    @IBAction func broadcastBack(_: UIButton) {
        previousPage()
    }

    @IBAction func handlePhotoButtonPressed(_: UIButton) {
        takeOrChoosePhoto()
    }

    @IBAction func handleDeleteButtonPressed(_: UIButton) {
        clearImages()
    }
}
