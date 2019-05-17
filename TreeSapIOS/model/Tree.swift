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
    let commonName: String
    let scientificName: String
    let location: CLLocation
    
    init(commonName: String, scientificName: String, location: CLLocation) {
        self.commonName = commonName
        self.scientificName = scientificName
        self.location = location
    }
}
