//
//  DataSource.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import CSVImporter
import Foundation
import MapKit

/// A class that contains the tree data from a source. The data is read in from an online database and is stored in a file
class DataSource {
    // MARK: - Properties

    /// The filename (and extension) of the local file.
    let localFilename: String
    /// A string representation of the data source's name, for user readability.
    let dataSourceName: String
    /// The format of CSV data contained in the data source. The CSV file will be parsed differently depending on this value.
    let csvFormat: CSVFormat
    /// An array of Tree objects collected by this data source.
    var trees: [Tree]

    init(localFilename: String, dataSourceName: String, csvFormat: CSVFormat) {
        self.localFilename = localFilename
        self.dataSourceName = dataSourceName
        self.csvFormat = csvFormat
        trees = [Tree]()
    }

    // MARK: - Functions

    func getTreeList() -> [Tree] {
        return trees
    }

    /**
     Creates Tree objects based on the file in the Documents directory with filename localFilename, and stores them in the trees array.
     - Returns: true if at least one tree was created.
     */
    func createTrees() -> Bool {
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
    
    // MARK: - Private functions

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
