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
    let id: Int?
    let commonName: String?
    let scientificName: String?
    let location: CLLocationCoordinate2D
    let dbh: Double?
    var otherInfo: [String: Double] = [:]
    var images: [UIImage] = []

    init(id: Int?, commonName: String?, scientificName: String?, location: CLLocationCoordinate2D, dbh: Double?) {
        // Initialize basic information
        self.id = id
        self.commonName = commonName
        self.scientificName = scientificName
        self.location = location
        self.dbh = dbh
    }

    func setOtherInfo(key: String, value: Double) {
        otherInfo[key] = value
    }
    
    func addImage(_ image: UIImage) {
        
    }
}
