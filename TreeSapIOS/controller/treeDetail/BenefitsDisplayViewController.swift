//
//  BenefitsDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class BenefitsDisplayViewController: TreeDisplayViewController {
    // MARK: - Properties

    @IBOutlet var benefitsContainer: UIView!
    @IBOutlet var noDataContainer: UIView!
    @IBOutlet var commonNameLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var dbhLabel: UILabel!
    @IBOutlet var totalAnnualBenefitsStackView: UIStackView!
    @IBOutlet var totalAnnualBenefitsDollarsLabel: UILabel!
    @IBOutlet var carbonSequestrationStackView: UIStackView!
    @IBOutlet var carbonSequestrationPoundsLabel: UILabel!
    @IBOutlet var carbonSequestrationDollarsLabel: UILabel!
    @IBOutlet var avoidedRunoffStackView: UIStackView!
    @IBOutlet var avoidedRunoffGallonsLabel: UILabel!
    @IBOutlet var avoidedRunoffDollarsLabel: UILabel!
    @IBOutlet var carbonAvoidedStackView: UIStackView!
    @IBOutlet var carbonAvoidedPoundsLabel: UILabel!
    @IBOutlet var carbonAvoidedDollarsLabel: UILabel!
    @IBOutlet var pollutionRemovalStackView: UIStackView!
    @IBOutlet var pollutionRemovalOuncesLabel: UILabel!
    @IBOutlet var pollutionRemovalDollarsLabel: UILabel!
    @IBOutlet var energySavingsStackView: UIStackView!
    @IBOutlet var energySavingsDollarsLabel: UILabel!

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

    // MARK: - Private functions

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
        if displayedTree!.otherInfo["carbonSequestrationPounds"] != nil {
            carbonSequestrationPoundsLabel.text = String(displayedTree!.otherInfo["carbonSequestrationPounds"]!) + " lbs"
        } else {
            carbonSequestrationPoundsLabel.isHidden = true
        }
        if displayedTree!.otherInfo["carbonSequestrationDollars"] != nil {
            carbonSequestrationDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["carbonSequestrationDollars"]!)
        } else {
            carbonSequestrationStackView.isHidden = true
        }
        if displayedTree!.otherInfo["avoidedRunoffCubicFeet"] != nil {
            avoidedRunoffGallonsLabel.text = String(format: "%.2f", displayedTree!.otherInfo["avoidedRunoffCubicFeet"]! * 7.48052) + " gal"
        } else {
            avoidedRunoffGallonsLabel.isHidden = true
        }
        if displayedTree!.otherInfo["avoidedRunoffDollars"] != nil {
            avoidedRunoffDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["avoidedRunoffDollars"]!)
        } else {
            avoidedRunoffStackView.isHidden = true
        }
        if displayedTree!.otherInfo["carbonAvoidedPounds"] != nil {
            carbonAvoidedPoundsLabel.text = String(format: "%.2f", displayedTree!.otherInfo["carbonAvoidedPounds"]!) + " lbs"
        } else {
            carbonAvoidedPoundsLabel.isHidden = true
        }
        if displayedTree!.otherInfo["carbonAvoidedDollars"] != nil {
            carbonAvoidedDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["carbonAvoidedDollars"]!)
        } else {
            carbonAvoidedStackView.isHidden = true
        }
        if displayedTree!.otherInfo["pollutionRemovalOunces"] != nil {
            pollutionRemovalOuncesLabel.text = String(format: "%.2f", displayedTree!.otherInfo["pollutionRemovalOunces"]!) + " oz"
        } else {
            pollutionRemovalOuncesLabel.isHidden = true
        }
        if displayedTree!.otherInfo["pollutionRemovalDollars"] != nil {
            pollutionRemovalDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["pollutionRemovalDollars"]!)
        } else {
            pollutionRemovalStackView.isHidden = true
        }
        if displayedTree!.otherInfo["energySavingsDollars"] != nil {
            energySavingsDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["energySavingsDollars"]!)
        } else {
            energySavingsStackView.isHidden = true
        }
    }
}
