//
//  FirstViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController {
	// MARK: Properties
	@IBOutlet weak var bigButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		bigButton.layer.cornerRadius = 150
    }

}

