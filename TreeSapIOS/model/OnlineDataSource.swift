//
//  OnlineDataSource.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Used https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory as a reference.
//

import CSVImporter
import Foundation
import MapKit

class OnlineDataSource: DataSource {
    /// The URL of the database where the tree data sets are stored.
    let internetFilebase: String = "https://faculty.hope.edu/jipping/treesap/"
    /// The filename (and extension) of the file that contains the online tree data.
    let internetFilename: String
    
    init(internetFilename: String, localFilename: String, dataSourceName: String, csvFormat: CSVFormat) {
        self.internetFilename = internetFilename
        super.init(localFilename: localFilename, dataSourceName: dataSourceName, csvFormat: csvFormat)
    }
    
    /**
     Retrieves online tree data from the URL specified by internetFilebase and internetFilename.
     Copies the online csv file to the app's documents directory, then calls createTrees to add Tree objects into the app.
     Stops if there is an error. This is done asynchronously.
     - Parameter loadingScreenActive: A Bool indicating whether the loading screen is active.
     */
    func retrieveOnlineData(loadingScreenActive: Bool) {
        // Retrieve the data from the URL
        let url = URL(string: internetFilebase + internetFilename)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            // Flag for if there is an error
            if error != nil {
                DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false, loadingScreenActive: loadingScreenActive)
                return
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false, loadingScreenActive: loadingScreenActive)
                    return
                }
                
                // Write the data to the documents directory
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURL = documentDirectory.appendingPathComponent(self.localFilename)
                    try data!.write(to: fileURL)
                } catch {
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false, loadingScreenActive: loadingScreenActive)
                    return
                }
            }
            // Create Tree objects for the data
            self.createTrees()
            DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: true, loadingScreenActive: loadingScreenActive)
        }
        task.resume()
    }
    
}
