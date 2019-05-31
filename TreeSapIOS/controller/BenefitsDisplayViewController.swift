//
//  NutritionFactsViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class BenefitsDisplayViewController: TreeDisplayViewController {
    // MARK: - Properties

    @IBOutlet weak var benefitsContainer: UIView!
    @IBOutlet weak var noDataContainer: UIView!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var dbhLabel: UILabel!
    @IBOutlet weak var totalAnnualBenefitsStackView: UIStackView!
    @IBOutlet weak var totalAnnualBenefitsDollarsLabel: UILabel!
    @IBOutlet weak var co2StackView: UIStackView!
    @IBOutlet weak var co2PoundsLabel: UILabel!
    @IBOutlet weak var co2DollarsLabel: UILabel!
    @IBOutlet weak var rainfallStackView: UIStackView!
    @IBOutlet weak var rainfallGallonsLabel: UILabel!
    @IBOutlet weak var rainfallDollarsLabel: UILabel!
    @IBOutlet weak var pollutionStackView: UIStackView!
    @IBOutlet weak var pollutionOuncesLabel: UILabel!
    @IBOutlet weak var pollutionDollarsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if displayedTree!.otherInfo != [:] {
            // Set label text
            setLabels()
            // Configure the benefits display
            benefitsContainer.layer.borderColor = UIColor.black.cgColor
            benefitsContainer.layer.borderWidth = 2
            noDataContainer.isHidden = true
        } else {
            benefitsContainer.isHidden = true
            // Show a message saying that the benefits could not be displayed
        }
}
    
    // MARK: - Private methods
    
    /// Sets the label text for the benefit display, hiding the ones that lack information.
    private func setLabels() {
        if displayedTree!.commonName != nil {
            commonNameLabel.text = displayedTree!.commonName!
        } else {
            commonNameLabel.text = "Yearly Benefits"
        }
        if displayedTree!.scientificName != nil {
            scientificNameLabel.text = displayedTree!.scientificName!
        } else {
            scientificNameLabel.isHidden = true
        }
        if displayedTree!.dbh != nil {
            dbhLabel.text = "Serving size (DBH): " + String(displayedTree!.dbh!) + "\""
        } else {
            dbhLabel.isHidden = true
        }
        if displayedTree!.otherInfo["totalAnnualBenefitsDollars"] != nil {
            totalAnnualBenefitsDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["totalAnnualBenefitsDollars"]!)
        } else {
            totalAnnualBenefitsStackView.isHidden = true
        }
        if displayedTree!.otherInfo["totalAnnualBenefitsDollars"] != nil {
            totalAnnualBenefitsDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["totalAnnualBenefitsDollars"]!)
        } else {
            totalAnnualBenefitsStackView.isHidden = true
        }
        if displayedTree!.otherInfo["co2Pounds"] != nil {
            co2PoundsLabel.text = String(displayedTree!.otherInfo["co2Pounds"]!) + " lbs"
        } else {
            co2PoundsLabel.isHidden = true
        }
        if displayedTree!.otherInfo["co2Dollars"] != nil {
            co2DollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["co2Dollars"]!)
        } else {
            co2StackView.isHidden = true
        }
        if displayedTree!.otherInfo["rainfallCubicFeet"] != nil {
            rainfallGallonsLabel.text = String(format: "%.2f", displayedTree!.otherInfo["rainfallCubicFeet"]! * 7.48052) + " gal"
        } else {
            rainfallGallonsLabel.isHidden = true
        }
        if displayedTree!.otherInfo["rainfallDollars"] != nil {
            rainfallDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["rainfallDollars"]!)
        } else {
            rainfallStackView.isHidden = true
        }
        if displayedTree!.otherInfo["pollutionOunces"] != nil {
            pollutionOuncesLabel.text = String(format: "%.2f", displayedTree!.otherInfo["pollutionOunces"]!) + " oz"
        } else {
            pollutionOuncesLabel.isHidden = true
        }
        if displayedTree!.otherInfo["pollutionDollars"] != nil {
            pollutionDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["pollutionDollars"]!)
        } else {
            pollutionStackView.isHidden = true
        }
    }
}
