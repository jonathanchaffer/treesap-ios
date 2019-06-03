//
//  NameFormatterTests.swift
//  TreeSapIOSTests
//
//  Created by Summer2019 on 6/3/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
@testable import TreeSapIOS

class NameFormatterTests: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testFormatCommonName() {
        XCTAssertEqual(NameFormatter.formatCommonName(commonName: "Sycamore-American"), "American Sycamore")
        XCTAssertEqual(NameFormatter.formatCommonName(commonName: "Big pine tree"), "Big Pine Tree")
        XCTAssertEqual(NameFormatter.formatCommonName(commonName: "Tree-Big ol'"), "Big Ol' Tree")
        XCTAssertEqual(NameFormatter.formatCommonName(commonName: "jonathan chaffer"), "Jonathan Chaffer")
        XCTAssertEqual(NameFormatter.formatCommonName(commonName: "jipping-mike"), "Mike Jipping")
    }
    
    func testFormatScientificName() {
        XCTAssertEqual(NameFormatter.formatScientificName(scientificName: "PLOC Platanus occidentalis"), "Platanus occidentalis")
        XCTAssertEqual(NameFormatter.formatScientificName(scientificName: "Big ol' pine tree"), "Big ol' pine tree")
        XCTAssertEqual(NameFormatter.formatScientificName(scientificName: "acer Saccharum"), "Acer saccharum")
        XCTAssertEqual(NameFormatter.formatScientificName(scientificName: "FRTR frog tree"), "Frog tree")
        XCTAssertEqual(NameFormatter.formatScientificName(scientificName: "This Is The Tree"), "This is the tree")

    }

}
