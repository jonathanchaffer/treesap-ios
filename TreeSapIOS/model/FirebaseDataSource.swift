//
//  FirebaseDataSource.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/17/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class FirebaseDataSource: DataSource {
    override func importOnlineTreeData() -> Bool {
        trees = [Tree]()
        retrieveFirebaseData()
        return true
    }
    
    func retrieveFirebaseData() {
        let collection = DatabaseManager.getPendingTreesCollection()
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
