//
//  CSVDataSource.swift
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

class CSVDataSource: DataSource {
    /// The URL of the database where the tree data sets are stored.
    let internetFilebase: String = "https://faculty.hope.edu/jipping/treesap/"
    /// The filename (and extension) of the file that contains the online tree data.
    let internetFilename: String
    /// The filename (and extension) of the local file.
    let localFilename: String
    /// The format of CSV data contained in the data source. The CSV file will be parsed differently depending on this value.
    let csvFormat: CSVFormat
    
    init(internetFilename: String, localFilename: String, dataSourceName: String, csvFormat: CSVFormat) {
        self.internetFilename = internetFilename
        self.localFilename = localFilename
        self.csvFormat = csvFormat
        super.init(dataSourceName: dataSourceName)
    }
    
    override func importOnlineTreeData() -> Bool {
        retrieveOnlineCSVData()
        return true
    }
    
    /**
     Retrieves online tree data from the URL specified by internetFilebase and internetFilename.
     Copies the online csv file to the app's documents directory, then calls createTrees to add Tree objects into the app.
     Stops if there is an error. This is done asynchronously.
     - Parameter loadingScreenActive: A Bool indicating whether the loading screen is active.
     */
    func retrieveOnlineCSVData() {
        // Retrieve the data from the URL
        let url = URL(string: internetFilebase + internetFilename)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            // Flag for if there is an error
            if error != nil {
                DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false)
                return
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false)
                    return
                }
                
                // Write the data to the documents directory
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURL = documentDirectory.appendingPathComponent(self.localFilename)
                    try data!.write(to: fileURL)
                } catch {
                    DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: false)
                    return
                }
            }
            // Create Tree objects for the data
            let loaded = self.loadTreesFromCSV()
            DataManager.reportLoadedData(dataSourceName: self.dataSourceName, success: loaded)
        }
        task.resume()
    }
    
    /**
     Creates Tree objects based on the file in the Documents directory with filename localFilename, and stores them in the trees array.
     - Returns: true if at least one tree was created.
     */
    // TODO: This function should return true if the CSV was properly read, i.e. the file exists, rather than if there was at least one tree created.
    func loadTreesFromCSV() -> Bool {
        // Create a file manager and get the path for the local file
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filepath = documentsURL.appendingPathComponent(localFilename).path
        var newTreeList = [Tree]()
        
        // Create an importer for the local file
        let importer = CSVImporter<[String]>(path: filepath)
        let importedRecords: [[String]] = importer.importRecords { $0 }
        // Create a Tree object for each imported record
        var treesCreated = false
        for record in importedRecords {
            let newTree: Tree? = makeTreeForRecord(record: record)
            if newTree != nil {
                newTreeList.append(newTree!)
                treesCreated = true
            }
        }
        trees = newTreeList
        return treesCreated
    }
    
    // MARK: - Helper functions
    
    /**
     Takes an array of strings and converts it to a Tree based on the CSV format.
     - Parameter record: An array of strings to be parsed.
     - Returns: A Tree object based on the inputted record.
     */
    private func makeTreeForRecord(record: [String]) -> Tree? {
        // Set ID (optional)
        var id: Int?
        if csvFormat.idIndex() >= 0 {
            id = Int(record[self.csvFormat.idIndex()])
        }
        // Set common name (optional)
        var commonName: String?
        if csvFormat.commonNameIndex() >= 0 {
            commonName = NameFormatter.formatCommonName(commonName: record[self.csvFormat.commonNameIndex()])
        }
        // Set scientific name (optional)
        var scientificName: String?
        if csvFormat.scientificNameIndex() >= 0 {
            scientificName = NameFormatter.formatScientificName(scientificName: record[self.csvFormat.scientificNameIndex()])
        }
        // Set latitude and longitude (required)
        let latitude = Double(record[self.csvFormat.latitudeIndex()])
        let longitude = Double(record[self.csvFormat.longitudeIndex()])
        // Set DBH (optional)
        var dbh: Double?
        if csvFormat.dbhIndex() >= 0 {
            dbh = Double(record[self.csvFormat.dbhIndex()])
        }
        if latitude != nil, longitude != nil {
            // Create the Tree object
            let tree = Tree(
                id: id,
                commonName: commonName,
                scientificName: scientificName,
                location: CLLocationCoordinate2D(latitude: latitude! as CLLocationDegrees, longitude: longitude! as CLLocationDegrees),
                dbh: dbh
            )
            
            // Set general benefit information
            if csvFormat.carbonSequestrationPoundsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonSequestrationPounds", value: Double(record[self.csvFormat.carbonSequestrationPoundsIndex()])!)
            }
            if csvFormat.carbonSequestrationDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonSequestrationDollars", value: Double(record[self.csvFormat.carbonSequestrationDollarsIndex()])!)
            }
            if csvFormat.avoidedRunoffCubicFeetIndex() >= 0 {
                tree.setOtherInfo(key: "avoidedRunoffCubicFeet", value: Double(record[self.csvFormat.avoidedRunoffCubicFeetIndex()])!)
            }
            if csvFormat.avoidedRunoffDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "avoidedRunoffDollars", value: Double(record[self.csvFormat.avoidedRunoffDollarsIndex()])!)
            }
            if csvFormat.carbonAvoidedPoundsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonAvoidedPounds", value: Double(record[self.csvFormat.carbonAvoidedPoundsIndex()])!)
            }
            if csvFormat.carbonAvoidedDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonAvoidedDollars", value: Double(record[self.csvFormat.carbonAvoidedDollarsIndex()])!)
            }
            if csvFormat.pollutionRemovalOuncesIndex() >= 0 {
                tree.setOtherInfo(key: "pollutionRemovalOunces", value: Double(record[self.csvFormat.pollutionRemovalOuncesIndex()])!)
            }
            if csvFormat.pollutionRemovalDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "pollutionRemovalDollars", value: Double(record[self.csvFormat.pollutionRemovalDollarsIndex()])!)
            }
            if csvFormat.energySavingsDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "energySavingsDollars", value: Double(record[self.csvFormat.energySavingsDollarsIndex()])!)
            }
            if csvFormat.totalAnnualBenefitsDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "totalAnnualBenefitsDollars", value: Double(record[self.csvFormat.totalAnnualBenefitsDollarsIndex()])!)
            }
            // Set breakdown benefit information
            if csvFormat.coDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "coDollars", value: Double(record[self.csvFormat.coDollarsIndex()])!)
            }
            if csvFormat.o3DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "o3Dollars", value: Double(record[self.csvFormat.o3DollarsIndex()])!)
            }
            if csvFormat.no2DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "no2Dollars", value: Double(record[self.csvFormat.no2DollarsIndex()])!)
            }
            if csvFormat.so2DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "so2Dollars", value: Double(record[self.csvFormat.so2DollarsIndex()])!)
            }
            if csvFormat.pm25DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "pm25Dollars", value: Double(record[self.csvFormat.pm25DollarsIndex()])!)
            }
            if csvFormat.heating1DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "heating1Dollars", value: Double(record[self.csvFormat.heating1DollarsIndex()])!)
            }
            if csvFormat.heating2DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "heating2Dollars", value: Double(record[self.csvFormat.heating2DollarsIndex()])!)
            }
            if csvFormat.coolingDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "coolingDollars", value: Double(record[self.csvFormat.coolingDollarsIndex()])!)
            }
            return tree
        }
        return nil
    }
}
