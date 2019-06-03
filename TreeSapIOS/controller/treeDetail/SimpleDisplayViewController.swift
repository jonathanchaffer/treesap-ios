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
    @IBOutlet weak var treeIDStackView: UIStackView!
    @IBOutlet var treeIDLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet weak var dbhStackView: UIStackView!
    @IBOutlet var dbhLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set common name label
        if displayedTree!.commonName != nil {
            commonNameLabel.text = displayedTree!.commonName
        } else {
            commonNameLabel.text = "Common Name N/A"
        }
        commonNameLabel.accessibilityValue = "commonNameLabel"
        // Set scientific name label
        if displayedTree!.scientificName != nil {
            scientificNameLabel.text = displayedTree!.scientificName
        } else {
            scientificNameLabel.isHidden = true
        }
        // Set tree ID label
        if displayedTree!.id != nil {
            treeIDLabel.text = String(displayedTree!.id!)
        } else {
            treeIDStackView.isHidden = true
        }
        // Set latitude and longitude labels
        latitudeLabel.text = String(displayedTree!.location.latitude)
        longitudeLabel.text = String(displayedTree!.location.longitude)
        // Set DBH label
        if displayedTree!.dbh != nil {
            dbhLabel.text = String(displayedTree!.dbh!)
        } else {
            dbhStackView.isHidden = true
        }
    }
}
