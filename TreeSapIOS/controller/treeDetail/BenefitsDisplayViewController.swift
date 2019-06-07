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
    @IBOutlet weak var carbonSequestrationStackView: UIStackView!
    @IBOutlet weak var carbonSequestrationPoundsLabel: UILabel!
    @IBOutlet weak var carbonSequestrationDollarsLabel: UILabel!
    @IBOutlet weak var avoidedRunoffStackView: UIStackView!
    @IBOutlet weak var avoidedRunoffGallonsLabel: UILabel!
    @IBOutlet weak var avoidedRunoffDollarsLabel: UILabel!
    @IBOutlet weak var carbonAvoidedStackView: UIStackView!
    @IBOutlet weak var carbonAvoidedPoundsLabel: UILabel!
    @IBOutlet weak var carbonAvoidedDollarsLabel: UILabel!
    @IBOutlet weak var pollutionRemovalStackView: UIStackView!
    @IBOutlet weak var pollutionRemovalOuncesLabel: UILabel!
    @IBOutlet weak var pollutionRemovalDollarsLabel: UILabel!
    @IBOutlet weak var energySavingsStackView: UIStackView!
    @IBOutlet weak var energySavingsDollarsLabel: UILabel!
    
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
