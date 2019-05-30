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

        // Set common name label
        if (self.displayedTree!.commonName != nil) {
            self.commonNameLabel.text = self.displayedTree!.commonName
        } else {
            self.commonNameLabel.text = "N/A"
        }
        // Set scientific name label
        if (self.displayedTree!.scientificName != nil) {
            self.scientificNameLabel.text = self.displayedTree!.scientificName
        } else {
            self.scientificNameLabel.text = "N/A"
        }
        // Set tree ID label
        if (self.displayedTree!.id != nil) {
            self.treeIDLabel.text = String(self.displayedTree!.id!)
        } else {
            self.treeIDLabel.text = "N/A"
        }
        // Set latitude and longitude labels
		self.latitudeLabel.text = String(self.displayedTree!.location.latitude)
		self.longitudeLabel.text = String(self.displayedTree!.location.longitude)
        // Set DBH label
        if (self.displayedTree!.dbh != nil) {
            self.dbhLabel.text = String(self.displayedTree!.dbh!)
        } else {
            self.dbhLabel.text = "N/A"
        }
    }
}
