//
//  AddTreeViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeViewController: UIViewController {
    @IBOutlet weak var useDeviceLocationButton: UIButton!
    @IBOutlet weak var addTreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up button styling
        useDeviceLocationButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        useDeviceLocationButton.layer.cornerRadius = 8.0
        addTreeButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        addTreeButton.layer.cornerRadius = 8.0
    }
    
    /// Closes the modal when the X button is tapped.
    @IBAction func closeAddTree(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
