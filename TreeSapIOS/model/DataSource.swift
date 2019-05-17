//
//  DataSource.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/17/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

class DataSource {
    let internetFilebase: String = "https://faculty.hope.edu/jipping/treesap/"
    let internetFilename: String
    let localFilename: String
    let dataSourceName: String
    
    init(internetFilename: String, localFilename: String, dataSourceName: String) {
        self.internetFilename = internetFilename
        self.localFilename = localFilename
        self.dataSourceName = dataSourceName
    }
    
    // TODO: Add better error handling
    func retrieveData() {
        // Retrieve the data from the URL
        let url = URL(string: self.internetFilebase + self.internetFilename)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error")
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
                }
            }
        }
        task.resume()
    }
}
