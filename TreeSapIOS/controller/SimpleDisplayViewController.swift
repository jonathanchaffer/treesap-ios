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
	@IBOutlet weak var latitudeLabel: UILabel!
	@IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var dbhLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.commonNameLabel.text = self.displayedTree!.commonName
        self.scientificNameLabel.text = self.displayedTree!.scientificName
        self.treeIDLabel.text = String(self.displayedTree!.id)
		self.latitudeLabel.text = String(self.displayedTree!.location.latitude)
		self.longitudeLabel.text = String(self.displayedTree!.location.longitude)
        self.dbhLabel.text = String(self.displayedTree!.dbh)
    }

}
