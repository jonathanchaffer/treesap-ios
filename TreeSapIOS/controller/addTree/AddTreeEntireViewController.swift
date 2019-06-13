//
//  AddTreeEntireViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeEntireViewController: AddTreePhotoViewController {
    // MARK: - Properties

    @IBOutlet var entireImageView: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        updateImage()
    }

    override func updateImage() {
        super.updateImage(imageView: entireImageView, nextButton: nextButton, skipButton: skipButton, deleteImageButton: deleteImageButton)
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
    
    @IBAction func handleDeleteImageButtonPressed(_ sender: UIButton) {
        deleteImage()
    }
}
