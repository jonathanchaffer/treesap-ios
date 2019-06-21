//
//  DatabaseManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class DatabaseManager {
    /// The Firestore database.
    static var db = Firestore.firestore()
    
    /**
     Uploads a created tree to the pending trees database. Alerts the user if there is an error.
     - Parameter tree: The Tree object to send to the database.
     */
    static func addTreeToPending(tree: Tree) {
        // Create the data object
        var data = [String:Any]()
        data["latitude"] = tree.location.latitude
        data["longitude"] = tree.location.longitude
        if tree.commonName != nil {
            data["commonName"] = tree.commonName!
        }
        if tree.scientificName != nil {
            data["scientificName"] = tree.scientificName!
        }
        if tree.id != nil {
            data["treeID"] = tree.id!
        }
        data["dbhArray"] = tree.dbhArray
        data["otherInfo"] = tree.otherInfo
        data["userID"] = AccountManager.getUserID()
        
        // Add the images to the data
        var encodedImages = [String]()
        for image in tree.images {
            let imageData = image.jpegData(compressionQuality: 0.1)!
            let encodedString = imageData.base64EncodedString(options: [])
            encodedImages.append(encodedString)
        }
        data["images"] = encodedImages
        data["timestamp"] = Timestamp()
        
        // Add the data to the pendingTrees database
        var ref: DocumentReference? = nil
        ref = db.collection("pendingTrees").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name("submitTreeFailure"), object: nil)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                NotificationCenter.default.post(name: NSNotification.Name("submitTreeSuccess"), object: nil)
            }
        }
    }
    
    /// - Returns: A Query containing a collection of pending trees for the current user, or nil if there is none.
    static func getPendingTreesCollection() -> Query? {
        if AccountManager.getUserID() != nil {
            return db.collection("pendingTrees").whereField("userID", isEqualTo: AccountManager.getUserID()!)
        } else {
            return nil
        }
    }
    
    /// - Returns: A Query containing the public trees collection, or nil if there is none.
    static func getPublicTreesCollection() -> Query? {
        return db.collection("acceptedTrees")
    }
}
