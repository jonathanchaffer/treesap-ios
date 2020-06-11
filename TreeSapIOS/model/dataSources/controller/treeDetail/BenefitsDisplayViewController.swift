//
//  BenefitsDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class BenefitsDisplayViewController: TreeDisplayViewController {
    // MARK: - Properties

    @IBOutlet var estimatedBenefitsLabel: UILabel!

    @IBOutlet var benefitsContainer: UIView!
    @IBOutlet var noDataContainer: UIView!
    @IBOutlet var commonNameLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var treeIDLabel: UILabel!

    @IBOutlet var dbhStackView: UIStackView!
    /**/ @IBOutlet var dbhLabel: UILabel!

    @IBOutlet var nativeStackView: UIStackView!
    /**/ @IBOutlet var nativeLabel: UILabel!

    @IBOutlet var totalAnnualBenefitsStackView: UIStackView!
    /**/ @IBOutlet var totalAnnualBenefitsDollarsLabel: UILabel!

    @IBOutlet var carbonSequestrationStackView: UIStackView!
    /**/ @IBOutlet var carbonSequestrationDollarsLabel: UILabel!
    /**/ @IBOutlet var carbonSequestrationPoundsStackView: UIStackView!
    /****/ @IBOutlet var carbonSequestrationPoundsLabel: UILabel!

    @IBOutlet var stormWaterStackView: UIStackView!
    /**/ @IBOutlet var stormWaterDollarsLabel: UILabel!
    /**/ @IBOutlet var avoidedRunoffStackView: UIStackView!
    /****/ @IBOutlet var avoidedRunoffGallonsLabel: UILabel!
    /**/ @IBOutlet var rainfallInterceptedGallonsStackView: UIStackView!
    /****/ @IBOutlet var rainfallInterceptedGallonsLabel: UILabel!

    @IBOutlet var pollutionRemovalStackView: UIStackView!
    /**/ @IBOutlet var pollutionRemovalDollarsLabel: UILabel!
    /**/ @IBOutlet var coOuncesStackView: UIStackView!
    /****/ @IBOutlet var coOuncesLabel: UILabel!
    /**/ @IBOutlet var o3OuncesStackView: UIStackView!
    /****/ @IBOutlet var o3OuncesLabel: UILabel!
    /**/ @IBOutlet var no2OuncesStackView: UIStackView!
    /****/ @IBOutlet var no2OuncesLabel: UILabel!
    /**/ @IBOutlet var so2OuncesStackView: UIStackView!
    /****/ @IBOutlet var so2OuncesLabel: UILabel!
    /**/ @IBOutlet var pm25OuncesStackView: UIStackView!
    /****/ @IBOutlet var pm25OuncesLabel: UILabel!

    @IBOutlet var energySavingsStackView: UIStackView!
    /**/ @IBOutlet var energySavingsDollarsLabel: UILabel!
    /**/ @IBOutlet var coolingKWHStackView: UIStackView!
    /****/ @IBOutlet var coolingKWHLabel: UILabel!
    /**/ @IBOutlet var heatingMBTUStackView: UIStackView!
    /****/ @IBOutlet var heatingMBTULabel: UILabel!

    @IBOutlet var avoidedEmissionsStackView: UIStackView!
    /**/ @IBOutlet var avoidedEmissionsDollarsLabel: UILabel!
    /**/ @IBOutlet var carbonAvoidedPoundsStackView: UIStackView!
    /****/ @IBOutlet var carbonAvoidedPoundsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show/hide the estimated benefits disclaimer
        if estimatedBenefitsFound! {
            estimatedBenefitsLabel.isHidden = false
        } else {
            estimatedBenefitsLabel.isHidden = true
        }

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
        // Common name
        if displayedTree!.commonName != nil {
            commonNameLabel.text = displayedTree!.commonName!
        } else {
            commonNameLabel.text = "Annual Tree Benefits"
        }
        // Scientific name
        if displayedTree!.scientificName != nil {
            scientificNameLabel.text = displayedTree!.scientificName!
        } else {
            scientificNameLabel.isHidden = true
        }
        // Tree ID
        treeIDLabel.text = "Tree ID: \(displayedTree!.id ?? 0)"
        // DBH
        if displayedTree!.dbhArray != [] {
            var dbhString = ""
            for i in 0 ..< displayedTree!.dbhArray.count - 1 {
                dbhString += String(displayedTree!.dbhArray[i]) + "\", "
            }
            dbhString += String(displayedTree!.dbhArray[displayedTree!.dbhArray.count - 1]) + "\""
            dbhLabel.text = dbhString
        } else {
            dbhStackView.isHidden = true
        }
        // Native
        if displayedTree!.native != nil {
            if displayedTree!.native! {
                nativeLabel.text = "Yes"
            } else {
                nativeLabel.text = "No"
            }
        } else {
            nativeStackView.isHidden = true
        }
        // Total annual benefits ($)
        if displayedTree!.otherInfo["totalAnnualBenefitsDollars"] != nil {
            totalAnnualBenefitsDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["totalAnnualBenefitsDollars"]!)
        } else {
            totalAnnualBenefitsStackView.isHidden = true
        }
        // Carbon sequestration ($)
        if displayedTree!.otherInfo["carbonSequestrationDollars"] != nil {
            carbonSequestrationDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["carbonSequestrationDollars"]!)
        } else {
            carbonSequestrationStackView.isHidden = true
        }
        // Carbon sequestration (lbs)
        if displayedTree!.otherInfo["carbonSequestrationPounds"] != nil {
            carbonSequestrationPoundsLabel.text = String(displayedTree!.otherInfo["carbonSequestrationPounds"]!) + " lbs"
        } else {
            carbonSequestrationPoundsStackView.isHidden = true
        }
        // Storm water runoff avoided ($)
        if displayedTree!.otherInfo["avoidedRunoffDollars"] != nil {
            stormWaterDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["avoidedRunoffDollars"]!)
        } else {
            stormWaterStackView.isHidden = true
        }
        // Avoided runoff (gal)
        if displayedTree!.otherInfo["avoidedRunoffCubicFeet"] != nil {
            avoidedRunoffGallonsLabel.text = String(format: "%.2f", displayedTree!.otherInfo["avoidedRunoffCubicFeet"]! * 7.48052) + " gal"
        } else {
            avoidedRunoffGallonsLabel.isHidden = true
        }
        // Rainfall intercepted (gal)
        if displayedTree!.otherInfo["waterInterceptedCubicFeet"] != nil {
            rainfallInterceptedGallonsLabel.text = String(format: "%.2f", displayedTree!.otherInfo["waterInterceptedCubicFeet"]! * 7.48052) + " gal"
        } else {
            rainfallInterceptedGallonsStackView.isHidden = true
        }
        // Pollution removal ($)
        if displayedTree!.otherInfo["pollutionRemovalDollars"] != nil {
            pollutionRemovalDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["pollutionRemovalDollars"]!)
        } else {
            pollutionRemovalStackView.isHidden = true
        }
        // Pollution removal - CO (oz)
        if displayedTree!.otherInfo["coOunces"] != nil {
            coOuncesLabel.text = String(displayedTree!.otherInfo["coOunces"]!) + " oz"
        } else {
            coOuncesStackView.isHidden = true
        }
        // Pollution removal - O3 (oz)
        if displayedTree!.otherInfo["o3Ounces"] != nil {
            o3OuncesLabel.text = String(displayedTree!.otherInfo["o3Ounces"]!) + " oz"
        } else {
            o3OuncesStackView.isHidden = true
        }
        // Pollution removal - NO2 (oz)
        if displayedTree!.otherInfo["no2Ounces"] != nil {
            no2OuncesLabel.text = String(displayedTree!.otherInfo["no2Ounces"]!) + " oz"
        } else {
            no2OuncesStackView.isHidden = true
        }
        // Pollution removal - SO2 (oz)
        if displayedTree!.otherInfo["so2Ounces"] != nil {
            so2OuncesLabel.text = String(displayedTree!.otherInfo["so2Ounces"]!) + " oz"
        } else {
            so2OuncesStackView.isHidden = true
        }
        // Pollution removal - PM2.5 (oz)
        if displayedTree!.otherInfo["pm25Ounces"] != nil {
            pm25OuncesLabel.text = String(displayedTree!.otherInfo["pm25Ounces"]!) + " oz"
        } else {
            pm25OuncesStackView.isHidden = true
        }
        // Energy savings ($)
        if displayedTree!.otherInfo["energySavingsDollars"] != nil {
            energySavingsDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["energySavingsDollars"]!)
        } else {
            energySavingsStackView.isHidden = true
        }
        // Energy savings - Cooling (kWh)
        if displayedTree!.otherInfo["coolingKWH"] != nil {
            coolingKWHLabel.text = String(displayedTree!.otherInfo["coolingKWH"]!) + " kWh"
        } else {
            coolingKWHStackView.isHidden = true
        }
        // Energy savings - Heating (MBTU)
        if displayedTree!.otherInfo["heatingMBTU"] != nil {
            heatingMBTULabel.text = String(displayedTree!.otherInfo["heatingMBTU"]!) + " MBTU"
        } else {
            heatingMBTUStackView.isHidden = true
        }
        // Avoided emissions ($)
        if displayedTree!.otherInfo["carbonAvoidedDollars"] != nil {
            avoidedEmissionsDollarsLabel.text = "$" + String(format: "%.2f", displayedTree!.otherInfo["carbonAvoidedDollars"]!)
        } else {
            avoidedEmissionsStackView.isHidden = true
        }
        // Avoided emissions - CO2 (lbs)
        if displayedTree!.otherInfo["carbonAvoidedPounds"] != nil {
            carbonAvoidedPoundsLabel.text = String(displayedTree!.otherInfo["carbonAvoidedPounds"]!) + " lbs"
        } else {
            carbonAvoidedPoundsStackView.isHidden = true
        }
    }
}
