//
//  AddTreeEntireViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeEntireViewController: AddTreePhotoViewController {
    // MARK: - Properties
    @IBOutlet weak var entireImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
    }
    
    override func updateImage() {
        if (selectedImage != nil) {
            entireImageView.image = selectedImage
            nextButton.isHidden = false
        }
    }

    // MARK: - Actions

    @IBAction func broadcastNext(_: UIButton) {
        nextPage()
    }
    
    @IBAction func handlePhotoButtonPressed(_ sender: UIButton) {
        takeOrChoosePhoto()
    }
}
