//
//  AddTreeLeafViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeLeafViewController: AddTreePhotoViewController {
    // MARK: - Properties

    @IBOutlet var leafImageView: UIImageView!
    @IBOutlet var nextButton: UIButton!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
    }

    override func updateImage() {
        if selectedImage != nil {
            leafImageView.image = selectedImage
            nextButton.isHidden = false
        }
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
}
