//
//  AddTreeViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // - MARK: Functions

    func nextPage() {
        NotificationCenter.default.post(name: NSNotification.Name(StringConstants.addTreeNextPageNotification), object: nil)
    }

    func previousPage() {
        NotificationCenter.default.post(name: NSNotification.Name(StringConstants.addTreePreviousPageNotification), object: nil)
    }
}
