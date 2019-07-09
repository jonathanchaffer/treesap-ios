//
//  NetworkManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager {
    static var reachability = Reachability()!
    static var isConnected = false
    
    static func setup() {
        reachability.whenReachable = { _ in
            print("Reachable")
            isConnected = true
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            AlertManager.alertUser(title: StringConstants.noConnectionListenerTitle, message: StringConstants.noConnectionListenerMessage)
            isConnected = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
