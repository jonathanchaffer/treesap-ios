//
//  AddTreeViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // - MARK: Methods

    func nextPage() {
        NotificationCenter.default.post(name: NSNotification.Name("next"), object: nil)
    }

    func previousPage() {
        NotificationCenter.default.post(name: NSNotification.Name("previous"), object: nil)
    }
}
