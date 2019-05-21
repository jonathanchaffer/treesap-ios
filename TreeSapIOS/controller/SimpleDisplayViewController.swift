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
    @IBOutlet weak var treeIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.commonNameLabel.text = self.displayedTree!.commonName
        self.scientificNameLabel.text = self.displayedTree!.scientificName
        self.treeIDLabel.text = "Tree ID: " + String(self.displayedTree!.id)
    }

}
