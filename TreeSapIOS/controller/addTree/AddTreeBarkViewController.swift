//
//  AddTreeBarkViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeBarkViewController: AddTreePhotoViewController {
    // MARK: - Properties
    @IBOutlet weak var barkImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
    }
    
    override func updateImage() {
        if (selectedImage != nil) {
            barkImageView.image = selectedImage
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
