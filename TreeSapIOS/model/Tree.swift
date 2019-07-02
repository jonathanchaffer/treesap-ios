//
//  Tree.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class Tree: Equatable {
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
    var documentID: String?
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

    static func == (tree1: Tree, tree2: Tree) -> Bool {
        return (tree1.id == tree2.id
            && tree1.commonName == tree2.commonName
            && tree1.scientificName == tree2.scientificName
            && tree1.location.latitude == tree2.location.latitude
            && tree1.location.longitude == tree2.location.longitude
            && tree1.dbhArray == tree2.dbhArray
            && tree1.native == tree2.native
            && tree1.otherInfo == tree2.otherInfo
            && tree1.images == tree2.images
            && tree1.userID == tree2.userID
            && tree1.timestamp == tree2.timestamp
            && tree1.documentID == tree2.documentID
            && tree1.notes == tree2.notes)
    }
}
