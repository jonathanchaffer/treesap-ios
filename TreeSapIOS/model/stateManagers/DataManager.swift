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
        CSVDataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland Tree Inventory", csvFormat: .holland),
        CSVDataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "Hope College i-Tree Data", csvFormat: .itree),
        CSVDataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College Trees", csvFormat: .hope),
        CSVDataSource(internetFilename: "katelyn.csv", localFilename: "benefits.csv", dataSourceName: "Tree Benefit Data", csvFormat: .benefits),
        FirebaseDataSource(dataSourceName: "My Pending Trees")
    ]
    
    /// Array that stores the result of a data task that reads tree data from an online file to a local file. Each element in the array is a tuple that contains the name of the data source and a Bool that indicates whether the loading of data was successful.
    static var reportedData = [(name: String, success: Bool)]()
    
    // MARK: - Static functions
    
    /**
     Imports CSV data for the CSV data sources.
     - Returns: true if at least one tree was created.
     */
    static func importAllLocalTreeData() -> Bool {
        var dataFound = false
        for dataSource in dataSources {
            if dataSource is CSVDataSource, (dataSource as! CSVDataSource).loadTreesFromCSV() {
                dataFound = true
            }
        }
        return dataFound
    }
    
    /**
     Imports each data source's tree data from online.
     */
    static func importAllOnlineTreeData() {
        for dataSource in dataSources {
            dataSource.importOnlineTreeData()
        }
        return
    }
    
    /**
     Stores whether a data successfully got data in reportedData. If all of the data tasks have finished, iterate through the result of each of the data tasks and alerts the user if less than all of the data could be loaded properly.
     - Parameter dataSourceName: The name of the data source that the data task is loading information from.
     - Parameter success: Whether the data task successfully loaded tree data from the online file into the local file.
     */
    static func reportLoadedData(dataSourceName: String, success: Bool) {
        // Store a report of whether the data was successfully loaded
        reportedData.append((dataSourceName, success))
        print(dataSourceName + ": " + String(success))
        // If not all data sources have been reported, return
        if reportedData.count != dataSources.count {
            return
        }
        
        // Check whether the loading screen is active
        var loadingScreen: LoadingScreenViewController? = nil
        DispatchQueue.main.async {
            loadingScreen = UIApplication.shared.keyWindow?.rootViewController as? LoadingScreenViewController
        }
        let loadingScreenActive = loadingScreen != nil
        
        // Check if any results were not loaded properly, and respond appropriately
        for (_, treesLoaded) in reportedData {
            if !treesLoaded {
                DispatchQueue.main.async {
                    if loadingScreen != nil {
                        loadingScreen!.showHomeScreen()
                    }
                }
                if !loadingScreenActive {
                    DispatchQueue.main.async {
                        AlertManager.alertUser(title: "Online tree data unavailable", message: "Some or all of the online tree data could not be loaded. The tree data stored on your device will be used instead.")
                    }
                } else {
                    DispatchQueue.main.async {
                        AlertManager.alertUser(title: "Some tree data unavailable", message: "Some or all of the tree data could not be loaded. Please make sure that your device is connected to the Internet and then restart the app.")
                    }
                }
            }
        }
        
        // If there were no issues with loading the online data, go to the home screen
        DispatchQueue.main.async {
            if loadingScreen != nil {
                loadingScreen!.showHomeScreen()
            }
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
}
