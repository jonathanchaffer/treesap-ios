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
            collection = DatabaseManager.getMyPendingTreesCollection()
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
            do {
                let data = document.data()!
                let id = data["treeID"] as? Int
                let commonName = NameFormatter.formatCommonName(commonName: data["commonName"] as? String)
                let scientificName = NameFormatter.formatScientificName(scientificName: data["scientificName"] as? String)
                guard let latitude = data["latitude"] as? Double else { throw DatabaseError.invalidDocumentData }
                guard let longitude = data["longitude"] as? Double else { throw DatabaseError.invalidDocumentData }
                let native = data["native"] as? Bool
                let userID = data["userID"] as? String
                guard let dbhArray = data["dbhArray"] as? [Double] else { throw DatabaseError.invalidDocumentData }
                let tree = Tree(
                    id: id,
                    commonName: commonName,
                    scientificName: scientificName,
                    location: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude),
                    native: native,
                    userID: userID)
                for dbh in dbhArray {
                    tree.addDBH(dbh)
                }
                // TODO: Add images and other info
                trees.append(tree)
            } catch {
                print("Error: The document \(document.documentID) could not be read.")
            }
        }
    }
}

enum DatabaseType {
    case pendingTrees, publicTrees
}

enum DatabaseError: Error {
    case invalidDocumentData
}
