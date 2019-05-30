//
//  Tree.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/17/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class Tree {
    // Basic information
    let id: Int?
    let commonName: String?
    let scientificName: String?
    let location: CLLocationCoordinate2D
    let dbh: Double?
    
    // Benefit information
    var totalAnnualBenefits: Double?
    var avoidedRunoffValue: Double?
    var pollutionValue: Double?
    var totalEnergySavings: Double?
    
    init(id: Int?, commonName: String?, scientificName: String?, location: CLLocationCoordinate2D, dbh: Double?,
         totalAnnualBenefits: Double?, avoidedRunoffValue: Double?, pollutionValue: Double?, totalEnergySavings: Double?) {
        // Initialize basic information
        self.id = id
        self.commonName = commonName
        self.scientificName = scientificName
        self.location = location
        self.dbh = dbh
        
        // Initialize benefit information
        self.totalAnnualBenefits = totalAnnualBenefits
        self.avoidedRunoffValue = avoidedRunoffValue
        self.pollutionValue = pollutionValue
        self.totalEnergySavings = totalEnergySavings
    }
}
