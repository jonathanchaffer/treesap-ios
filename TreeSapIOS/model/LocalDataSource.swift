//
//  LocalDataSource.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import CSVImporter
import Foundation
import MapKit

class LocalDataSource: DataSource {
    let header = "id,commonName,scientificName,latitude,longitude,dbh\n"
    
    /// Adds a tree to the local data source.
    func addTree(_ tree: Tree) {
        self.trees.append(tree)
        saveTreesToCSV()
    }
    
    /// Generates a csv file for the currently stored trees and saves it to the app's documents directory.
    func saveTreesToCSV() {
        // Generate the contents of the csv
        var csvText = header
        for tree in trees {
            if tree.id != nil {
                csvText.append(String(tree.id!))
            }
            csvText.append(",")
            if tree.commonName != nil {
                csvText.append(tree.commonName!)
            }
            csvText.append(",")
            if tree.scientificName != nil {
                csvText.append(tree.scientificName!)
            }
            csvText.append(",")
            csvText.append(String(tree.location.latitude))
            csvText.append(",")
            csvText.append(String(tree.location.longitude))
            csvText.append(",")
            if tree.dbh != nil {
                csvText.append(String(tree.dbh!))
            }
            csvText.append("\n")
        }
        // Save the csv to a local file
        writeToCSV(text: csvText)
    }
    
    func createEmptyCSV() {
        writeToCSV(text: header)
    }
    
    private func writeToCSV(text: String) {
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentsURL.appendingPathComponent(localFilename)
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("error saving to csv file")
        }
    }
}
