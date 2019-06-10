//
//  AddTreeViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
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
