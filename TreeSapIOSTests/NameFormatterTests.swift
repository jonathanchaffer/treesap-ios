//
//  NameFormatterTests.swift
//  TreeSapIOSTests
//
//  Created by CS Student on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
@testable import TreeSapIOS
import CSVImporter

class NameFormatterTests: XCTestCase {
        
        func testFormatCommonName(){
            for index in 0..<commonNameTestStrings.count {
                XCTAssertEqual(NameFormatter.formatCommonName(commonName: commonNameTestStrings[index]), commonNameExpectedResults[index])
            }
        }
        
        func testFormatScientificName(){
            for index in 0..<scientificNameTestStrings.count{
                XCTAssertEqual(NameFormatter.formatScientificName(scientificName: scientificNameTestStrings[index]), scientificNameExpectedResults[index])
            }
        }
    
        //MARK: Test Cases and Expected Results
        //common name test cases
        let commonNameTestStrings: [String] = ["Sugar maple", "Crimson King Maple", "Ginkgo", "Unknown", "Mulberry-Red", "Pine-Eastern White", "Dogwood-Flowering", "Crabapple-Japanese Flowering"]
        let commonNameExpectedResults: [String] = ["Sugar maple", "Crimson King Maple", "Ginkgo", "Unknown", "Red Mulberry", "Eastern White Pine", "Flowering Dogwood", "Japanese Flowering Crabapple"]
    
        //scientific name test cases
        let scientificNameTestStrings: [String] = ["Acer saccharum", "", "Acer x freemanii", "Acer rubrum", "MORU Morus rubra", "PIAB Picea ables", "MAFL80 Malus floribunda", "ACSA1 Acer saccharinum", "ACSA2 Acer saccharum", "GLTR Geditsia triacanthos"]
        let scientificNameExpectedResults: [String] = ["Acer saccharum", "", "Acer x freemanii", "Acer rubrum", "Morus rubra", "Picea ables", "Malus floribunda", "Acer saccharinum", "Acer saccharum", "Geditsia triacanthos"]
}
