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
    
    init(dataSourceName: String, databaseType: DatabaseType) {
        self.databaseType = databaseType
        super.init(dataSourceName: dataSourceName)
    }
    
    // MARK: - Functions
    override func importOnlineTreeData() {
        trees = [Tree]()
        retrieveFirebaseData()
    }
    
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
    
    func loadTreesFromDocuments(documents: [DocumentSnapshot]) {
        for document in documents {
            let data = document.data()!
            let tree = Tree(
                id: data["treeID"] as? Int,
                commonName: data["commonName"] as? String,
                scientificName: data["scientificName"] as? String,
                location: CLLocationCoordinate2D(
                    latitude: data["latitude"] as! Double,
                    longitude: data["longitude"] as! Double),
                dbh: data["dbh"] as? Double)
            // TODO: Add images and other info
            trees.append(tree)
        }
    }
}

enum DatabaseType {
    case pendingTrees, publicTrees
}
