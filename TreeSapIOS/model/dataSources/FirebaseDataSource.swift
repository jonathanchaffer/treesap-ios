//
//  FirebaseDataSource.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class FirebaseDataSource: DataSource {
    // MARK: - Properties
    var databaseType: DatabaseType? = nil
    
    // MARK: - Initializers
    init(dataSourceName: String, databaseType: DatabaseType) {
        self.databaseType = databaseType
        super.init(dataSourceName: dataSourceName)
    }
    
    // MARK: - Mutators
    override func importOnlineTreeData() {
        trees = [Tree]()
        retrieveFirebaseData()
    }
    
    /// Retrieves online tree data from Firebase, then calls loadTreesFromDocuments. Reports to the data manager whether retrieval was successful.
    func retrieveFirebaseData() {
        var collection: Query? = nil
        if self.databaseType == .pendingTrees {
            collection = DatabaseManager.getPendingTreesCollection()
        } else if self.databaseType == .publicTrees {
            collection = DatabaseManager.getPublicTreesCollection()
        }
        if collection != nil {
            collection!.getDocuments() { snapshot, error in
                if let error = error {
                    print("Error retrieving documents: \(error)")
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false)
                } else {
                    self.loadTreesFromDocuments(documents: snapshot!.documents)
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: true)
                }
            }
        }
        DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: true)
    }
    
    /**
     Creates Tree objects based on an array of documents, and stores them in the trees array.
     */
    func loadTreesFromDocuments(documents: [DocumentSnapshot]) {
        for document in documents {
            let data = document.data()!
            let tree = Tree(
                id: data["treeID"] as? Int,
                commonName: NameFormatter.formatCommonName(commonName: data["commonName"] as? String),
                scientificName: NameFormatter.formatScientificName(scientificName: data["scientificName"] as? String),
                location: CLLocationCoordinate2D(
                    latitude: data["latitude"] as! Double,
                    longitude: data["longitude"] as! Double),
                dbh: data["dbh"] as? Double,
                userID: data["userID"] as? String)
            // TODO: Add images and other info
            trees.append(tree)
        }
    }
}

enum DatabaseType {
    case pendingTrees, publicTrees
}
