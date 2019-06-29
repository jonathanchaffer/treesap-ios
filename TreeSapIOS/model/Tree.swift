//
//  Tree.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class Tree {
    let id: Int?
    let commonName: String?
    let scientificName: String?
    let location: CLLocationCoordinate2D
    var dbhArray = [Double]()
    let native: Bool?
    var otherInfo = [String: Double]()
    var images = [ImageCategory.bark: [UIImage](),
                  ImageCategory.leaf: [UIImage](),
                  ImageCategory.full: [UIImage]()]
    let userID: String?
    var timestamp: Double?
    var documentID: String? = nil
    var notes = [String]()

    init(id: Int?, commonName: String?, scientificName: String?, location: CLLocationCoordinate2D, native: Bool?, userID: String?) {
        // Initialize basic information
        self.id = id
        self.commonName = commonName
        self.scientificName = scientificName
        self.location = location
        self.native = native
        self.userID = userID
    }
    
    func addDBH(_ newDBH: Double) {
        dbhArray.append(newDBH)
    }

    func setOtherInfo(key: String, value: Double) {
        otherInfo[key] = value
    }

    func addImage(_ image: UIImage, toCategory category: ImageCategory) {
        images[category]!.append(image)
    }
    
    func addNote(note: String) {
        notes.append(note)
    }
}
