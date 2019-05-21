//
//  SimpleDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class SimpleDisplayViewController: TreeDisplayViewController {
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.commonNameLabel.text = self.displayedTree?.commonName
        self.scientificNameLabel.text = self.displayedTree?.scientificName
    }

}
