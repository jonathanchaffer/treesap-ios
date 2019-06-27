//
//  NotificationDetailsViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {
    // MARK: - Properties
    var data: [String: Any]?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var dbhLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification"
        navigationController?.setToolbarHidden(true, animated: false)
        setupLabels()
    }
    
    // MARK: - Private functions
    private func setupLabels() {
        let accepted = data!["accepted"]! as! Bool
        let comments = data!["message"]! as! String
        let treeData = data!["treeData"]! as! [String: Any]
        let commonName = treeData["commonName"]! as! String
        let scientificName = treeData["scientificName"]! as! String
        let latitude = treeData["latitude"]! as! Double
        let longitude = treeData["longitude"] as! Double
        let dbhArray = treeData["dbhArray"]! as! [Double]

        // Set title and subtitle
        if accepted {
            titleLabel.text = "Tree Accepted"
            if commonName != "" {
                subtitleLabel.text = "Your \(commonName) has been added to the database."
            } else {
                subtitleLabel.text = "Your tree has been added to the database."
            }
        } else {
            titleLabel.text = "Tree Rejected"
            if commonName != "" {
                subtitleLabel.text = "Your \(commonName) was removed from the database."
            } else {
                subtitleLabel.text = "Your tree was removed from the database."
            }
            
        }
        
        // Set common name and scientific name labels
        if commonName != "" {
            commonNameLabel.text = commonName
        } else {
            commonNameLabel.text = "N/A"
        }
        if scientificName != "" {
            scientificNameLabel.text = scientificName
        } else {
            scientificNameLabel.text = "N/A"
        }
        
        // Set latitude and longitude labels
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
        
        // Set DBH label
        if dbhArray != [] {
            var dbhString = ""
            for i in 0 ..< dbhArray.count - 1 {
                dbhString += String(dbhArray[i]) + "\", "
            }
            dbhString += String(dbhArray[dbhArray.count - 1]) + "\""
            dbhLabel.text = dbhString
        } else {
            dbhLabel.text = "N/A"
        }
        
        // Set comments label
        if comments != "" {
            commentsLabel.text = comments
        } else {
            commentsLabel.text = "(none)"
        }
    }
}
