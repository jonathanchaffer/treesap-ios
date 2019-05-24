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
import CSVImporter
import MapKit

/// A class that contains the tree data from a source. The data is read in from an online database and is stored in a file
class DataSource {
    /// The URL of the database where the tree data sets are stored.
    let internetFilebase: String = "https://faculty.hope.edu/jipping/treesap/"
    /// The filename (and extension) of the file that contains the online tree data.
    let internetFilename: String
    /// The filename (and extension) of the local file.
    let localFilename: String
    /// A string representation of the data source's name, for user readability.
    let dataSourceName: String
    /// The format of CSV data contained in the data source. The CSV file will be parsed differently depending on this value.
    let csvFormat: CSVFormat
    /// An array of Tree objects collected by this data source.
    var trees: [Tree]
    /// Whether the data source should be included in searches, maps, etc.
    var isActive: Bool
    
    init(internetFilename: String, localFilename: String, dataSourceName: String, csvFormat: CSVFormat, isActive: Bool) {
        self.internetFilename = internetFilename
        self.localFilename = localFilename
        self.dataSourceName = dataSourceName
        self.csvFormat = csvFormat
        self.trees = [Tree]()
        self.isActive = isActive
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
                } catch {
                    print(error)
                    isErrorFree = false
                    return
                }
                
                // Create Tree objects for the data
                DispatchQueue.main.async {
                    self.createTrees()
                }
            }
        }
        
        if(isErrorFree){
            task.resume()
        }
        
        return isErrorFree
    }
    
    /**
     Creates Tree objects based on the file in the Documents directory with filename localFilename. Tree objects are stored in the trees array.
     */
    func createTrees() {
        // Create a file manager and get the path for the local file
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filepath = documentsURL.appendingPathComponent(self.localFilename).path
        // Create an importer for the local file
        let importer = CSVImporter<[String]>(path: filepath)
        importer.startImportingRecords { $0 }.onFinish { importedRecords in
            // Create a Tree object for each imported record
            for record in importedRecords {
                let id = Int(record[self.csvFormat.idIndex()])
                let commonName = NameFormatter.formatCommonName(commonName: record[self.csvFormat.commonNameIndex()])
                let scientificName = NameFormatter.formatScientificName(scientificName: record[self.csvFormat.scientificNameIndex()])
                let latitude = Double(record[self.csvFormat.latitudeIndex()])
                let longitude = Double(record[self.csvFormat.longitudeIndex()])
                let dbh = Double(record[self.csvFormat.dbhIndex()])
                if (latitude != nil && longitude != nil && id != nil) {
                    let tree = Tree(
                        id: id!,
                        commonName: commonName,
                        scientificName: scientificName,
                        location:CLLocationCoordinate2D(
                            latitude: latitude! as CLLocationDegrees,
                            longitude: longitude! as CLLocationDegrees
                    ), dbh: dbh!)
                    self.trees.append(tree)
                }
            }
        }
    }
    
    func getTreeList() -> [Tree] {
        return trees
    }
}
