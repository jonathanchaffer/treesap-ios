//
//  AddTreeViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    ///closes the modal (i.e. the page thing that appears in front of the previous view)
    @IBAction func closeAddTree(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
