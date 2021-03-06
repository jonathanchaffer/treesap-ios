//
//  FirebaseDataSource.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Firebase
import Foundation
import MapKit

class FirebaseDataSource: DataSource {
    // MARK: - Properties

    var databaseType: DatabaseType?

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
        var collection: Query?
        if databaseType == .myPendingTrees {
            collection = DatabaseManager.getMyPendingTreesCollection()
        } else if databaseType == .allPendingTrees {
            collection = DatabaseManager.getAllPendingTreesCollection()
        } else if databaseType == .publicTrees {
            collection = DatabaseManager.getPublicTreesCollection()
        } 
        if collection != nil {
            collection!.getDocuments { snapshot, error in
                if let error = error {
                    print("Error retrieving documents: \(error)")
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false)
                    NotificationCenter.default.post(name: NSNotification.Name(StringConstants.firebaseDataRetrievalFailureNotification), object: self)
                } else {
                    self.loadTreesFromDocuments(documents: snapshot!.documents)
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: true)
                    NotificationCenter.default.post(name: NSNotification.Name(StringConstants.firebaseDataRetrievalSuccessNotification), object: self)
                }
            }
        }
        DataManager.reportLoadedData(dataSourceName: dataSourceName, success: true)
        NotificationCenter.default.post(name: NSNotification.Name(StringConstants.firebaseDataRetrievalSuccessNotification), object: self)
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
                let tree = Tree(
                    id: id,
                    commonName: commonName,
                    scientificName: scientificName,
                    location: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude
                    ),
                    native: native,
                    userID: userID
                )
                guard let dbhArray = data["dbhArray"] as? [Double] else { throw DatabaseError.invalidDocumentData }
                for dbh in dbhArray {
                    tree.addDBH(dbh)
                }
                guard let notes = data["notes"] as? [String] else { throw DatabaseError.invalidDocumentData }
                for note in notes {
                    tree.addNote(note: note)
                }
                tree.documentID = document.documentID
                tree.timestamp = Double((data["timestamp"] as! Timestamp).seconds)
                guard let imageMap = data["images"] as? [String: [String]] else { throw DatabaseError.invalidDocumentData }
                for imageCategory in imageMap.keys {
                    let images = imageMap[imageCategory]!
                    for encodedImage in images {
                        let decodedImage = DatabaseManager.convertBase64ToImage(encodedImage: encodedImage)
                        if decodedImage != nil {
                            if imageCategory == "bark" {
                                tree.addImage(decodedImage!, toCategory: .bark)
                            } else if imageCategory == "leaf" {
                                tree.addImage(decodedImage!, toCategory: .leaf)
                            } else if imageCategory == "full" {
                                tree.addImage(decodedImage!, toCategory: .full)
                            }
                        }
                    }
                }
                trees.append(tree)
            } catch {
                print("Error: The document \(document.documentID) could not be read.")
            }
        }
    }
}

enum DatabaseType {
    case myPendingTrees, allPendingTrees, publicTrees, allTreeAlerts
}

enum DatabaseError: Error {
    case invalidDocumentData
}
