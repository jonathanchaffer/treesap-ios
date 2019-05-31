//
//  SimpleDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class SimpleDisplayViewController: TreeDisplayViewController {
    @IBOutlet var commonNameLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var treeIDLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var dbhLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set common name label
        if displayedTree!.commonName != nil {
            commonNameLabel.text = displayedTree!.commonName
        } else {
            commonNameLabel.text = "Common Name N/A"
        }
        // Set scientific name label
        if displayedTree!.scientificName != nil {
            scientificNameLabel.text = displayedTree!.scientificName
        } else {
            scientificNameLabel.text = "Scientific Name N/A"
        }
        // Set tree ID label
        if displayedTree!.id != nil {
            treeIDLabel.text = String(displayedTree!.id!)
        } else {
            treeIDLabel.text = "N/A"
        }
        // Set latitude and longitude labels
        latitudeLabel.text = String(displayedTree!.location.latitude)
        longitudeLabel.text = String(displayedTree!.location.longitude)
        // Set DBH label
        if displayedTree!.dbh != nil {
            dbhLabel.text = String(displayedTree!.dbh!)
        } else {
            dbhLabel.text = "N/A"
        }
    }
}
