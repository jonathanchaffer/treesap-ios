//
//  DataManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class DataManager {
    // MARK: - Properties
    
    /// Array of data sources. This is where all data sources are initialized. NOTE: This should only contain one local data source. If there are multiple, all user-created trees will just be added to the first local data source.
    static var dataSources: [DataSource] = [
        OnlineDataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland Tree Inventory", csvFormat: .holland),
        OnlineDataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "Hope College i-Tree Data", csvFormat: .itree),
        OnlineDataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College Trees", csvFormat: .hope),
        OnlineDataSource(internetFilename: "katelyn.csv", localFilename: "benefits.csv", dataSourceName: "Tree Benefit Data", csvFormat: .benefits),
        LocalDataSource(localFilename: "mytrees.csv", dataSourceName: "My Trees (Local)", csvFormat: .mytrees)
    ]
    
    /// Array that stores the result of a data task that reads tree data from an online file to a local file. Each element in the array is a tuple that contains the name of the data source and a Bool that indicates whether the loading of data was successful.
    static var reportedData = [(name: String, success: Bool)]()
    
    // MARK: - Static functions
    
    /**
     Imports each data source's tree data from online.
     - Parameter loadingScreenActive: Whether the loading screen is active.
     */
    static func importOnlineTreeData(loadingScreenActive: Bool) {
        for dataSource in dataSources {
            if dataSource is OnlineDataSource {
                (dataSource as! OnlineDataSource).retrieveOnlineData(loadingScreenActive: loadingScreenActive)
            }
            if dataSource is LocalDataSource {
                reportLoadedData(dataSourceName: dataSource.dataSourceName, success: true, loadingScreenActive: loadingScreenActive)
            }
        }
        return
    }
    
    /**
     Calls createTrees on each data source.
     - Returns: true if at least one tree was created.
     */
    static func importLocalTreeData() -> Bool {
        var dataFound = false
        for dataSource in dataSources {
            if dataSource.createTrees() {
                dataFound = true
            }
        }
        return dataFound
    }
    
    /**
     Stores whether a data successfully got data in reportedData. If all of the data tasks have finished, iterate through the result of each of the data tasks and alerts the user if less than all of the data could be loaded properly.
     - Parameter dataSourceName: The name of the data source that the data task is loading information from.
     - Parameter success: Whether the data task successfully loaded tree data from the online file into the local file.
     */
    static func reportLoadedData(dataSourceName: String, success: Bool, loadingScreenActive: Bool) {
        reportedData.append((dataSourceName, success))
        if reportedData.count != dataSources.count {
            return
        }
        
        // Check if any results were not loaded and respond appropriately
        for (_, resultsLoaded) in reportedData {
            if !resultsLoaded {
                if loadingScreenActive {
                    DispatchQueue.main.async {
                        AlertManager.alertUser(title: "Online tree data unavailable", message: "Some or all of the online tree data could not be loaded. The tree data stored on your device will be used instead.")
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        let currentViewController = UIApplication.shared.keyWindow?.rootViewController as? LoadingScreenViewController
                        if currentViewController != nil {
                            currentViewController!.showHomeScreen()
                        }
                        
                        AlertManager.alertUser(title: "Some tree data unavailable", message: "Some or all of the tree data could not be loaded. Please make sure that your device is connected to the Internet and then restart the app.")
                        return
                    }
                }
            }
        }
        
        // If there are not issues with loading the online data, go to the home screen
        DispatchQueue.main.async {
            guard let currentViewController = UIApplication.shared.keyWindow?.rootViewController as? LoadingScreenViewController else {
                return
            }
            currentViewController.showHomeScreen()
        }
    }
    
    /**
     - Parameter name: The name of the data source to retrieve.
     - Returns: The DataSource with the given name.
     */
    static func getDataSourceWithName(name: String) -> DataSource? {
        for dataSource in dataSources {
            if dataSource.dataSourceName == name {
                return dataSource
            }
        }
        
        return nil
    }
    
    /// - Returns: The local data source. NOTE: If there are multiple local data sources (which there shouldn't be), this will just return the first of them.
    static func getLocalDataSource() -> LocalDataSource? {
        for dataSource in dataSources {
            if dataSource is LocalDataSource {
                return (dataSource as! LocalDataSource)
            }
        }
        return nil
    }
}
