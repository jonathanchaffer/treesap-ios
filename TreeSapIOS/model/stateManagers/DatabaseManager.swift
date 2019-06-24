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
    /// Array of curator user IDs.
    static var curators = [String]()
    
    /// Sets up the list of curators.
    static func setup() {
        db.collection("curators").getDocuments() { snapshot, error in
            if let error = error {
                print("Error retrieving curators: \(error)")
            } else {
                for document in snapshot!.documents {
                    curators.append(document.documentID)
                }
            }
        }
    }
    
    /**
     Creates a data object based on the specified tree and adds it to the pending trees collection.
     - Parameter tree: The tree to submit.
     */
    static func submitTreeToPending(tree: Tree) {
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
        data["notes"] = tree.notes
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
        
        // Add the data to the collection
        addDataToCollection(data: data, collectionID: "pendingTrees", documentID: nil)
    }
    
    /**
     Moves an existing document from pendingTrees to acceptedTrees.
     - Parameter documentID: The ID of the document to move.
     */
    static func moveDataToAccepted(documentID: String) {
        let ref = db.collection("pendingTrees").document(documentID)
        ref.getDocument() { document, err in
            if let err = err {
                print("Error retrieving document: \(err)")
            } else {
                addDataToCollection(data: document!.data()!, collectionID: "acceptedTrees", documentID: documentID)
                removeDataFromCollection(collectionID: "pendingTrees", documentID: documentID)
            }
        }
    }
    
    /**
     Removes an existing document from pendingTrees.
     - Parameter documentID: The ID of the document to remove.
     */
    static func removeDataFromPending(documentID: String) {
        removeDataFromCollection(collectionID: "pendingTrees", documentID: documentID)
    }
    
    /**
     Adds or overwrites a document to a collection in the database.
     - Parameter data: The data object to upload to the database.
     - Parameter collectionID: The ID of the collection in which the document should be stored.
     - Parameter documentID: The ID of the document to overwrite, or nil if no documents should be overwritten (i.e. a new document should be created).
     */
    fileprivate static func addDataToCollection(data: [String:Any], collectionID: String, documentID: String?) {
        var ref: DocumentReference? = nil
        if documentID == nil {
            ref = db.collection(collectionID).addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    NotificationCenter.default.post(name: NSNotification.Name("submitTreeFailure"), object: nil)
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    NotificationCenter.default.post(name: NSNotification.Name("submitTreeSuccess"), object: nil)
                }
            }
        } else {
            db.collection(collectionID).document(documentID!).setData(data) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    NotificationCenter.default.post(name: NSNotification.Name("updateTreeFailure"), object: nil)
                } else {
                    print("Document updated with ID: \(documentID!)")
                    NotificationCenter.default.post(name: NSNotification.Name("updateTreeSuccess"), object: nil)
                }
            }
        }
    }
    
    /**
     Removes a document from a collection in the database.
     - Parameter collectionID: The ID of the collection from which the document should be removed.
     - Parameter documentID: The ID of the document to remove.
     */
    fileprivate static func removeDataFromCollection(collectionID: String, documentID: String) {
        db.collection(collectionID).document(documentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name("deleteTreeFailure"), object: nil)
            } else {
                print("Document successfully removed!")
                NotificationCenter.default.post(name: NSNotification.Name("deleteTreeSuccess"), object: nil)
            }
        }
    }
    
    /// - Returns: A Query containing a collection of pending trees for the current user, or nil if there is none.
    static func getMyPendingTreesCollection() -> Query? {
        if AccountManager.getUserID() != nil {
            return db.collection("pendingTrees").whereField("userID", isEqualTo: AccountManager.getUserID()!)
        } else {
            return nil
        }
    }
    
    /// - Returns: A Query containing a collection of pending trees for all users, or nil if there is none.
    static func getAllPendingTreesCollection() -> Query? {
        return db.collection("pendingTrees")
    }
    
    /// - Returns: A Query containing the public trees collection, or nil if there is none.
    static func getPublicTreesCollection() -> Query? {
        return db.collection("acceptedTrees")
    }
}
