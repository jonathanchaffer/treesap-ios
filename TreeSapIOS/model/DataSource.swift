//
//  DataSource.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/17/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  used code from https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory as a reference
//

import CSVImporter
import Foundation
import MapKit

/// A class that contains the tree data from a source. The data is read in from an online database and is stored in a file
class DataSource {
    // MARK: - Properties
    
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
    
    init(internetFilename: String, localFilename: String, dataSourceName: String, csvFormat: CSVFormat) {
        self.internetFilename = internetFilename
        self.localFilename = localFilename
        self.dataSourceName = dataSourceName
        self.csvFormat = csvFormat
        trees = [Tree]()
    }
    
    // MARK: - Methods
    
    /// Retrieves online tree data from the URL specified using the internet filename and internet filebase properties. Copies the online csv file to the app's documents directory, then creating Tree objects in the data sources using the data in the local repositories.  Stops if there is an error. This is done asynchronously.
    func retrieveOnlineData(loadingScreenActive: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Retrieve the data from the URL
        let url = URL(string: internetFilebase + internetFilename)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            // Flag for if there is an error
            if error != nil {
                DispatchQueue.main.async {
                    appDelegate.handleDataLoadingReport(dataSourceName: self.dataSourceName, success: false, loadingScreenActive: loadingScreenActive)
                }
                return
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
                    appDelegate.handleDataLoadingReport(dataSourceName: self.dataSourceName, success: false, loadingScreenActive: loadingScreenActive)
                    return
                }
                
                // Write the data to the documents directory
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURL = documentDirectory.appendingPathComponent(self.localFilename)
                    try data!.write(to: fileURL)
                } catch {
                    DispatchQueue.main.async {
                        appDelegate.handleDataLoadingReport(dataSourceName: self.dataSourceName, success: false, loadingScreenActive: loadingScreenActive)
                    }
                    return
                }
            }
            // Create Tree objects for the data
            let errorFree: Bool = self.createTrees(asynchronous: false)
            DispatchQueue.main.async {
                appDelegate.handleDataLoadingReport(dataSourceName: self.dataSourceName, success: errorFree, loadingScreenActive: loadingScreenActive)
            }
        }
        
        task.resume()
    }
    
    func getTreeList() -> [Tree] {
        return trees
    }
    
    // MARK: - Private methods
    
    /**
     Creates Tree objects based on the file in the Documents directory with filename localFilename. Tree objects are stored in the trees array.
     - Parameter asynchronous: Whether the creation of trees should be done asynchronously rather than synchronously
     - Returns: True if at least one tree was imported from a local file and false otherwise
     */
    public func createTrees(asynchronous: Bool) -> Bool{
        // Create a file manager and get the path for the local file
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filepath = documentsURL.appendingPathComponent(localFilename).path
        var newTreeList = [Tree]()
        
        // Create an importer for the local file
        let importer = CSVImporter<[String]>(path: filepath)
        if(asynchronous){
            importer.startImportingRecords { $0 }.onFinish { importedRecords in
                // Create a Tree object for each imported record
                for record in importedRecords {
                    let newTree: Tree? = self.makeTreeForRecord(record: record)
                    if(newTree != nil){
                        newTreeList.append(newTree!)
                    }
                }
                
                //TODO: Potentially add a lock to the trees array during this line of code. If not, this line should be outside of both the if and else blocks
                self.trees = newTreeList
            }
        }else{
            let importedRecords: [[String]] = importer.importRecords { $0 }
            // Create a Tree object for each imported record
            for record in importedRecords {
                let newTree: Tree? = self.makeTreeForRecord(record: record)
                if(newTree != nil){
                    newTreeList.append(newTree!)
                }
            }
            
            self.trees = newTreeList
        }
        
        return (self.trees.count > 0)
    }
    
    private func makeTreeForRecord(record: [String]) -> Tree?{
        // Set ID (optional)
        var id: Int?
        if self.csvFormat.idIndex() >= 0 {
            id = Int(record[self.csvFormat.idIndex()])
        }
        // Set common name (optional)
        var commonName: String?
        if self.csvFormat.commonNameIndex() >= 0 {
            commonName = NameFormatter.formatCommonName(commonName: record[self.csvFormat.commonNameIndex()])
        }
        // Set scientific name (optional)
        var scientificName: String?
        if self.csvFormat.scientificNameIndex() >= 0 {
            scientificName = NameFormatter.formatScientificName(scientificName: record[self.csvFormat.scientificNameIndex()])
        }
        // Set latitude and longitude (required)
        let latitude = Double(record[self.csvFormat.latitudeIndex()])
        let longitude = Double(record[self.csvFormat.longitudeIndex()])
        // Set DBH (optional)
        var dbh: Double?
        if self.csvFormat.dbhIndex() >= 0 {
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
            if self.csvFormat.carbonSequestrationPoundsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonSequestrationPounds", value: Double(record[self.csvFormat.carbonSequestrationPoundsIndex()])!)
            }
            if self.csvFormat.carbonSequestrationDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonSequestrationDollars", value: Double(record[self.csvFormat.carbonSequestrationDollarsIndex()])!)
            }
            if self.csvFormat.avoidedRunoffCubicFeetIndex() >= 0 {
                tree.setOtherInfo(key: "avoidedRunoffCubicFeet", value: Double(record[self.csvFormat.avoidedRunoffCubicFeetIndex()])!)
            }
            if self.csvFormat.avoidedRunoffDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "avoidedRunoffDollars", value: Double(record[self.csvFormat.avoidedRunoffDollarsIndex()])!)
            }
            if self.csvFormat.carbonAvoidedPoundsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonAvoidedPounds", value: Double(record[self.csvFormat.carbonAvoidedPoundsIndex()])!)
            }
            if self.csvFormat.carbonAvoidedDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "carbonAvoidedDollars", value: Double(record[self.csvFormat.carbonAvoidedDollarsIndex()])!)
            }
            if self.csvFormat.pollutionRemovalOuncesIndex() >= 0 {
                tree.setOtherInfo(key: "pollutionRemovalOunces", value: Double(record[self.csvFormat.pollutionRemovalOuncesIndex()])!)
            }
            if self.csvFormat.pollutionRemovalDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "pollutionRemovalDollars", value: Double(record[self.csvFormat.pollutionRemovalDollarsIndex()])!)
            }
            if self.csvFormat.energySavingsDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "energySavingsDollars", value: Double(record[self.csvFormat.energySavingsDollarsIndex()])!)
            }
            if self.csvFormat.totalAnnualBenefitsDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "totalAnnualBenefitsDollars", value: Double(record[self.csvFormat.totalAnnualBenefitsDollarsIndex()])!)
            }
            // Set breakdown benefit information
            if self.csvFormat.coDollarsIndex() >= 0 {
                tree.setOtherInfo(key: "coDollars", value: Double(record[self.csvFormat.coDollarsIndex()])!)
            }
            if self.csvFormat.o3DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "o3Dollars", value: Double(record[self.csvFormat.o3DollarsIndex()])!)
            }
            if self.csvFormat.no2DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "no2Dollars", value: Double(record[self.csvFormat.no2DollarsIndex()])!)
            }
            if self.csvFormat.so2DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "so2Dollars", value: Double(record[self.csvFormat.so2DollarsIndex()])!)
            }
            if self.csvFormat.pm25DollarsIndex() >= 0 {
                tree.setOtherInfo(key: "pm25Dollars", value: Double(record[self.csvFormat.pm25DollarsIndex()])!)
            }
            
            return tree
        }
            return nil
    }
}
