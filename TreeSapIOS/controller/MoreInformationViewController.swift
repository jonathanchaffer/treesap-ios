//
//  MoreInformationViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class MoreInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func closeMoreInformation(_ sender: UIBarButtonItem) {
		navigationController?.popViewController(animated: true)
		dismiss(animated: true, completion: nil)
	}
	
}
