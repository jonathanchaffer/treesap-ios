//
//  UnreadManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Firebase
import Foundation

class UnreadManager {
    /// The Firestore database.
    static var db = Firestore.firestore()
    /// The number of unread notifications.
    static var numUnreadNotifications = 0

    static func retrieveNumberOfUnreadNotifications() {
        if AccountManager.getUserID() != nil {
            let query = db.collection("notifications").whereField(FieldPath(["treeData", "userID"]), isEqualTo: AccountManager.getUserID()!).whereField("read", isEqualTo: false)
            query.getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                } else {
                    numUnreadNotifications = snapshot!.count
                    NotificationCenter.default.post(name: NSNotification.Name(StringConstants.unreadNotificationsCountNotification), object: nil)
                }
            }
        } else {
            return
        }
    }
}
