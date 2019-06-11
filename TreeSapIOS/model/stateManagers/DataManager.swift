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

    /// Array of data sources. This is where all data sources are initialized. Add to this array to add additional data sources.
    static var dataSources: [DataSource] = [
        DataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland Tree Inventory", csvFormat: .holland),
        DataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "Hope College i-Tree Data", csvFormat: .itree),
        DataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College Trees", csvFormat: .hope),
        DataSource(internetFilename: "katelyn.csv", localFilename: "benefits.csv", dataSourceName: "Tree Benefit Data", csvFormat: .benefits),
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
            dataSource.retrieveOnlineData(loadingScreenActive: loadingScreenActive)
        }
        return
    }

    /**
     Creates Tree objects in each DataSource object using data from the local tree data repositiories.
     - Returns: A Bool that indicates whether each of the data sources contained some data.
     */
    static func importLocalTreeData() -> Bool {
        var allDataPresent = true // indicates whether any of the data sources contain no data (which indicates they could not be loaded)
        for dataSource in dataSources {
            if !dataSource.createTrees() {
                allDataPresent = false
            }
        }
        return allDataPresent
    }

    /// Calls handleDataLoadingReportWithLoadingScreen with the given parameters if the loadingScreenActive parameter is true and calls handleDataLoadingReportWithNoLoadingScreen with the given parameters of if the loadingScreenActive if it is false
    static func handleDataLoadingReport(dataSourceName: String, success: Bool, loadingScreenActive: Bool) {
        if loadingScreenActive {
            handleDataLoadingReportWithLoadingScreen(dataSourceName: dataSourceName, success: success)
        } else {
            handleDataLoadingReportWithNoLoadingScreen(dataSourceName: dataSourceName, success: success)
        }
    }

    /**
     Stores the details of a data task that loads tree data from an online. If all of the data tasks that load information from the online data sources have finished, then this function iterates through the result of each of the data tasks and alerts the user if less than all of the data could be loaded properly.
     - Parameter dataSourceName: The name of the data source that the data task is loading information from.
     - Parameter success: Whether the data task successfully loaded tree data from the online file into the local file.
     */
    static func handleDataLoadingReportWithNoLoadingScreen(dataSourceName: String, success: Bool) {
        reportedData.append((dataSourceName, success))
        if reportedData.count != dataSources.count {
            return
        }

        for (_, resultsLoaded) in reportedData {
            if !resultsLoaded {
                DispatchQueue.main.async {
                    AlertManager.alertUser(title: "Online tree data unavailable", message: "Some or all of the online tree data could not be loaded. The tree data stored on your device will be used instead.")
                }
                return
            }
        }
    }

    /**
     Stores the details of a data task that loads tree data from an online. If all of the data tasks that load information from the online data sources have finished, then this function iterates through the result of each of the data tasks and checks if any of them did not load properly. If any did not load properly, the home screen is made the "active screen" if the loading screen is the "active screen" and the user is alerted.
     - Parameter dataSourceName: The name of the data source that the data task is loading information from.
     - Parameter success: Whether the data task successfully loaded tree data from the online file into the local file.
     */
    static func handleDataLoadingReportWithLoadingScreen(dataSourceName: String, success: Bool) {
        reportedData.append((dataSourceName, success))
        if reportedData.count != dataSources.count {
            return
        }

        for (_, resultsLoaded) in reportedData {
            // If there are any issues with loading the onlie data, go to the home screen and alert the user
            if !resultsLoaded {
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
}
