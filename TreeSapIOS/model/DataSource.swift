//
//  DataSource.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/17/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  used code from https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory as a reference
//

import Foundation
/// A class that contains the tree data from a source. The data is read in from an online database and is stored in a file
class DataSource {
    /// the URL of the database where the tree data sets are stored
    let internetFilebase: String = "https://faculty.hope.edu/jipping/treesap/"
    /// the name of the file that contains the data that is used by this class
    let internetFilename: String
    /// the name the created file that contains the data is/will be given
    let localFilename: String
    let dataSourceName: String
    
    init(internetFilename: String, localFilename: String, dataSourceName: String) {
        self.internetFilename = internetFilename
        self.localFilename = localFilename
        self.dataSourceName = dataSourceName
    }
    
    /**
     Retrieves online tree data from the URL specified using the internet filename and internet filebase properties. Stops if there is an error, but catches the error. Used code from https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory as a reference.
     
     - Returns: true if there is no error and false if there was an error
     */
    func retrieveOnlineData() -> Bool{
        // Flag for if there is an error (needed for errors in void function)
        var isErrorFree: Bool = true
        
        // Retrieve the data from the URL
        let url = URL(string: self.internetFilebase + self.internetFilename)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error!)
                isErrorFree = false
                return
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error")
                    isErrorFree = false
                    return
                }
                
                // Write the data to the documents directory
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURL = documentDirectory.appendingPathComponent(self.localFilename)
                    try data!.write(to: fileURL)
                    print("Wrote " + self.internetFilename + " to " + documentDirectory.relativePath + " as " + self.localFilename)
                } catch {
                    print(error)
                    isErrorFree = false
                    return
                }
            }
        }
        
        if(isErrorFree){
            task.resume()
        }
        
        return isErrorFree
    }
}
