//
//  DataSourceTests.swift
//  TreeSapIOSTests
//
//  Created by Josiah Brett on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import CSVImporter
@testable import TreeSapIOS
import XCTest

class DataSourceTests: XCTestCase {
    var hollandSource: CSVDataSource!
    var iTreeSource: CSVDataSource!
    var hopeSource: CSVDataSource!

    override func setUp() {
        hollandSource = CSVDataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland", csvFormat: CSVFormat.holland)
        iTreeSource = CSVDataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "iTree", csvFormat: CSVFormat.itree)
        hopeSource = CSVDataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College", csvFormat: CSVFormat.hope)
    }

    override func tearDown() {}

    func testHollandSource() {
        guard let fileText: String = readInFile(fileName: hollandSource.localFilename) else {
            XCTFail("The local City of Holland file could not be found.")
            return
        }

        guard fileText.contains(hollandTextStart) else {
            XCTFail("The local City of Holland file does not contain the text at the beginning of the online City of Holland file.")
            return
        }

        guard fileText.contains(hollandTextEnd) else {
            XCTFail("The local City of Holland file does not contain the text at the end of the online City of Holland file.")
            return
        }

        guard fileText.contains(hollandTextMiddle1) else {
            XCTFail("The local City of Holland file does not contain the text (selection 1) in the middle of the online City of Holland file.")
            return
        }

        guard fileText.contains(hollandTextMiddle2) else {
            XCTFail("The local City of Holland file does not contain the text (selection 2) in the middle of the online City of Holland file.")
            return
        }

        guard fileText.contains(hollandTextMiddle3) else {
            XCTFail("The local City of Holland file does not contain the text (selection 3) in the middle of the online City of Holland file.")
            return
        }

        guard fileText.contains(hollandTextMiddle4) else {
            XCTFail("The local City of Holland file does not contain the text (selection 4) in the middle of the online City of Holland file.")
            return
        }
    }

    func testHopeSource() {
        guard let fileText: String = readInFile(fileName: hopeSource.localFilename) else {
            XCTFail("The local Hope College file could not be found.")
            return
        }

        guard fileText.contains(hopeTextStart) else {
            XCTFail("The local Hope College file does not contain the text at the beginning of the online Hope College file.")
            return
        }

        guard fileText.contains(hopeTextEnd) else {
            XCTFail("The local Hope College file does not contain the text at the end of the online Hope College file.")
            return
        }

        guard fileText.contains(hopeTextMiddle1) else {
            XCTFail("The local Hope College file does not contain the text (selection 1) in the middle of the online Hope College file.")
            return
        }

        guard fileText.contains(hopeTextMiddle2) else {
            XCTFail("The local Hope College file does not contain the text (selection 2) in the middle of the online Hope College file.")
            return
        }

        guard fileText.contains(hopeTextMiddle3) else {
            XCTFail("The local Hope College file does not contain the text (selection 3) in the middle of the online Hope College file.")
            return
        }
    }

    func testITreeSource() {
        guard let fileText: String = readInFile(fileName: iTreeSource.localFilename) else {
            XCTFail("The local iTree file could not be found.")
            return
        }

        guard fileText.contains(iTreeTextStart) else {
            XCTFail("The local iTree file does not contain the text at the beginning of the online iTree file.")
            return
        }

        guard fileText.contains(iTreeTextEnd) else {
            XCTFail("The local iTree file does not contain the text at the end of the online iTree file.")
            return
        }

        guard fileText.contains(iTreeTextMiddle1) else {
            XCTFail("The local iTree file does not contain the text (selection 1) in the middle of the online iTree file.")
            return
        }

        guard fileText.contains(iTreeTextMiddle2) else {
            XCTFail("The local iTree file does not contain the text (selection 2) in the middle of the online iTree file.")
            return
        }

        guard fileText.contains(iTreeTextMiddle3) else {
            XCTFail("The local iTree file does not contain the text (selection 3) in the middle of the online iTree file.")
            return
        }

        guard fileText.contains(iTreeTextMiddle4) else {
            XCTFail("The local iTree file does not contain the text (selection 4) in the middle of the online iTree file.")
            return
        }
    }

    // Based on code from https://www.seemuapps.com/read-to-and-write-from-a-text-file-in-swift
    func readInFile(fileName: String) -> String? {
        guard let documentDirectoryURL: URL = try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }

        let fileURL: URL = documentDirectoryURL.appendingPathComponent(fileName)

        guard let fileText: String = try? String(contentsOf: fileURL) else {
            return nil
        }

        return fileText
    }

    // MARK: - Copied File Text

    // NOTE: Do not use multi-line strings.

    // City of Holland test text
    let hollandTextStart: String = "OBJECTID,CommonName,Scientific,DBH,CreationDa,Creator,EditDate,Editor,GlobalID,Park,Notes,DBH2,DBH3,Native_Non,DBH4,Latitude,Longitude"
    let hollandTextEnd: String = "2340,Callery pear,,9.92000000000,6/12/2018,GIS_Intern_BPW,6/12/2018,GIS_Intern_BPW,{B252D089-25E0-4DB3-8ABD-49C5856F84BD},,,0.00000000000,0.00000000000,,0.00000000000,42.77288035900,-86.12688797300"
    let hollandTextMiddle1: String = "1,Sugar maple,Acer saccharum,30.29999923710,5/8/2018,A.Ebenstein_BPW,5/8/2018,A.Ebenstein_BPW,{BE11A77A-F5DA-4959-A8BA-4279B133F762},Centennial Park,,0.00000000000,0.00000000000,,0.00000000000,42.78839462500,-86.10745071800"
    let hollandTextMiddle2: String = "179,White oak,Quercus alba,29.94000053410,5/8/2018,A.Ebenstein_BPW,5/8/2018,A.Ebenstein_BPW,{F6396C4F-28A0-434C-9699-80A333F6FDA9},Kollen Park,,0.00000000000,0.00000000000,,0.00000000000,42.78816665900,-86.12177598400"
    let hollandTextMiddle3: String = "1235,Little leaf linden,,12.60000000000,5/25/2018,GIS_Intern_BPW,5/25/2018,GIS_Intern_BPW,{A4F7FE14-50AC-4791-9C70-A87EDC15F78A},,,0.00000000000,0.00000000000,,0.00000000000,42.78798351400,-86.06134303300"
    let hollandTextMiddle4: String = "2279,Red oak,,1.47000000000,6/12/2018,GIS_Intern_BPW,6/12/2018,GIS_Intern_BPW,{F33BF5A5-8F99-4037-9204-215EFCA0AE9A},,,0.00000000000,0.00000000000,,0.00000000000,42.77155818400,-86.12667097600"

    // Hope College test text
    let hopeTextStart: String = "Tree ID,Host ID,Common Name,Additional Taxonomic Information,Latitude,Longitude,Location type,Location value,Location rating,DBH height,DBH 1,DBH 2,DBH 3,DBH 4,DBH 5,DBH 6,Age class,Condition class,Canopy radius,Height class,Tree Asset Value,Planting type,Stems,Root infringement,Tree notes,Overall Risk Rating,Evaluation notes,Evaluation Date,Plant part of concern,Primary target,Secondary target,Advanced assessment crown,Advanced assessment roots,Advanced assessment stem,Defect type,Defect type,Defect type,Defect type,Defect type,Defect type,Defect other,Overhead lines,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease other,Pest notes,Dedicated,Dedication type,Description,Honoree,Dedication year,Dedication notes,Contributor"
    let hopeTextEnd: String = "200,GLTR Gleditsia triacanthos,Honeylocust-Common,...,42.78752136,-86.10177612,Open,Good,...,4.5,16,0,0,0,0,0,Mature,Good,20,Medium,5864.37,1,1,25-50%,...,...,...,...,...,N/A,N/A,No,No,No,N/A,N/A,N/A,N/A,N/A,N/A,...,...,N/A,N/A,N/A,N/A,N/A,N/A,...,...,No,N/A,...,...,...,...,..."
    let hopeTextMiddle1: String = "1,MORU Morus rubra,Mulberry-Red ,...,42.78870773,-86.10109711,Open,Good,...,4.5,33,0,0,0,0,0,Mature,Good,30,Large,9820.6,1,1,51-75%,removed 6-2014,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    let hopeTextMiddle2: String = "85,MAFL80 Malus floribunda,Crabapple-Japanese Flowering,...,42.78779221,-86.10171509,Open,Good,...,1,5,0,0,0,0,0,Semi-mature,Good,8,Small,2234.05,3,1,<25%,...,...,...,...,...,N/A,N/A,No,No,No,N/A,N/A,N/A,N/A,N/A,N/A,...,...,N/A,N/A,N/A,N/A,N/A,N/A,...,...,No,N/A,...,...,...,...,..."
    let hopeTextMiddle3: String = "160,PR Prunus sp,Cherry,...,42.78718185,-86.1034317,Foundation,Good,...,4,15,0,0,0,0,0,Mature,Good,15,Medium,3461.85,1,1,<25%,...,...,...,...,...,N/A,N/A,No,No,No,Wound-stem,N/A,N/A,N/A,N/A,N/A,...,...,N/A,N/A,N/A,N/A,N/A,N/A,...,...,No,N/A,...,...,...,...,..."

    // iTree test text
    let iTreeTextStart: String = "Tree ID,Host ID,Common Name,Additional Taxonomic Information,Latitude,Longitude,Location type,Location value,Location rating,DBH height,DBH 1,DBH 2,DBH 3,DBH 4,DBH 5,DBH 6,Age class,Condition class,Canopy radius,Height class,Tree Asset Value,Planting type,Stems,Root infringement,Tree notes,Overall Risk Rating,Evaluation notes,Evaluation Date,Plant part of concern,Primary target,Secondary target,Advanced assessment crown,Advanced assessment roots,Advanced assessment stem,Defect type,Defect type,Defect type,Defect type,Defect type,Defect type,Defect other,Overhead lines,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease type,Pest or disease other,Pest notes,Dedicated,Dedication type,Description,Honoree,Dedication year,Dedication notes,Contributor"
    let iTreeTextEnd: String = "200,GLTR Gleditsia triacanthos,Honeylocust-Common,...,42.78752136,-86.10177612,Open,Good,...,4.5,16,0,0,0,0,0,Mature,Good,20,Medium,5864.37,1,1,25-50%,...,...,...,...,...,N/A,N/A,No,No,No,N/A,N/A,N/A,N/A,N/A,N/A,...,...,N/A,N/A,N/A,N/A,N/A,N/A,...,...,No,N/A,...,...,...,...,..."
    let iTreeTextMiddle1: String = "1,MORU Morus rubra,Mulberry-Red ,...,42.78870773,-86.10109711,Open,Good,...,4.5,33,0,0,0,0,0,Mature,Good,30,Large,9820.6,1,1,51-75%,removed 6-2014,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
    let iTreeTextMiddle2: String = "for construction of a steam pit ,...,...,...,...,N/A,N/A,Yes,No,Yes,Cavity-stem,Wound-root flare,Wound-branch,Dead branches <=2,N/A,N/A,...,,N/A,N/A,N/A,N/A,N/A,N/A,...,...,No,N/A,...,...,...,...,...,,,,,,,,,,,,,,,,,,,,,,,,"
    let iTreeTextMiddle3: String = "75,ACSA2 Acer saccharum,Maple-Sugar,...,42.78804016,-86.1019516,Open,Good,...,4.5,25,0,0,0,0,0,Mature,Good,30,Large,15757.48,1,1,25-50%,...,...,...,...,...,N/A,N/A,No,No,No,N/A,N/A,N/A,N/A,N/A,N/A,...,...,N/A,N/A,N/A,N/A,N/A,N/A,...,...,No,N/A,...,...,...,...,..."
    let iTreeTextMiddle4: String = "199,COFL Cornus florida,Dogwood-Flowering,...,42.78753281,-86.10188294,Foundation,Good,...,4.5,7,0,0,0,0,0,Mature,Good,15,Small,1085.85,1,1,<25%,...,...,...,...,...,N/A,N/A,No,No,No,N/A,N/A,N/A,N/A,N/A,N/A,...,...,N/A,N/A,N/A,N/A,N/A,N/A,...,...,No,N/A,...,...,...,...,..."
}
