//
//  AddTreeBarkViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeBarkViewController: AddTreePhotoViewController {
    // MARK: - Properties

    @IBOutlet var barkImageView: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var deleteImageButton: UIButton!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        updateImage()
    }

    override func updateImage() {
        super.updateImage(imageView: barkImageView, nextButton: nextButton, skipButton: skipButton, deleteImageButton: deleteImageButton)
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
        deleteImage()
    }
}
