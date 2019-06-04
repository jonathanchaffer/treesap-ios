//
//  AddTreeViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class OldAddTreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Closes the modal when the X button is tapped.
    @IBAction func closeAddTree(_: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
