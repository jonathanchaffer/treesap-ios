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
        var encodedImageMap = [String: [String]]()
        for imageCategory in tree.images.keys {
            var encodedImages = [String]()
            for image in tree.images[imageCategory]! {
                let imageData = image.jpegData(compressionQuality: 0.1)!
                let encodedString = imageData.base64EncodedString(options: [])
                encodedImages.append(encodedString)
            }
            encodedImageMap[imageCategory.toString()] = encodedImages
        }
        data["images"] = encodedImageMap
        
        data["timestamp"] = Timestamp()
        
        // Add the data to pending
        addDataToCollection(data: data, collectionID: "pendingTrees", documentID: nil)
    }
    
    /**
     Moves an existing document from pendingTrees to acceptedTrees.
     - Parameter documentID: The ID of the document to move.
     */
    static func acceptDocumentFromPending(documentID: String) {
        let ref = db.collection("pendingTrees").document(documentID)
        ref.getDocument() { document, err in
            if let err = err {
                print("Error retrieving document: \(err)")
            } else {
                // Add the tree to accepted
                addDataToCollection(data: document!.data()!, collectionID: "acceptedTrees", documentID: documentID)
                // Remove the tree from pending
                removeDataFromCollection(collectionID: "pendingTrees", documentID: documentID)
            }
        }
    }
    
    /**
     Removes an existing document from pendingTrees.
     - Parameter documentID: The ID of the document to remove.
     */
    static func rejectDocumentFromPending(documentID: String) {
        let ref = db.collection("pendingTrees").document(documentID)
        ref.getDocument() { document, err in
            if let err = err {
                print("Error retrieving document: \(err)")
            } else {
                // Remove the tree from pending
                removeDataFromCollection(collectionID: "pendingTrees", documentID: documentID)
            }
        }
    }
    
    /**
     Removes an existing document from notifications.
     - Parameter documentID: The ID of the document to remove.
     */
    static func removeDocumentFromNotifications(documentID: String) {
        removeDataFromCollection(collectionID: "notifications", documentID: documentID)
    }
    
    /**
     Adds a document to the notifications collection with data about whether a given tree was accepted or rejected.
     - Parameter userID: The ID of the user to send the notification to.
     - Parameter accepted: Whether the tree was accepted.
     - Parameter message: An optional message to send to the user.
     - Parameter documentID: The document ID of the tree in question.
     */
    static func sendNotificationToUser(userID: String, accepted: Bool, message: String, documentID: String) {
        let ref = db.collection("pendingTrees").document(documentID)
        ref.getDocument() { document, err in
            if let err = err {
                print("Error retrieving document: \(err)")
            } else {
                // Add the notification to notifications
                addDataToCollection(data: ["accepted": accepted, "treeData": document!.data()!, "message": message, "read": false, "timestamp": Timestamp()], collectionID: "notifications", documentID: nil)
            }
        }
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
                    NotificationCenter.default.post(name: NSNotification.Name("submitDataFailure"), object: nil)
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    NotificationCenter.default.post(name: NSNotification.Name("submitDataSuccess"), object: nil)
                }
            }
        } else {
            db.collection(collectionID).document(documentID!).setData(data) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    NotificationCenter.default.post(name: NSNotification.Name("updateDataFailure"), object: nil)
                } else {
                    print("Document updated with ID: \(documentID!)")
                    NotificationCenter.default.post(name: NSNotification.Name("updateDataSuccess"), object: nil)
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
                NotificationCenter.default.post(name: NSNotification.Name("deleteDataFailure"), object: nil)
            } else {
                print("Document successfully removed!")
                NotificationCenter.default.post(name: NSNotification.Name("deleteDataSuccess"), object: nil)
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
    
    /// - Returns: A Query containing a collection of notifications for the current user, or nil if there is none.
    static func getNotificationsCollection() -> Query? {
        if AccountManager.getUserID() != nil {
            return db.collection("notifications").whereField(FieldPath(["treeData", "userID"]), isEqualTo: AccountManager.getUserID()!)
        } else {
            return nil
        }
    }
}
