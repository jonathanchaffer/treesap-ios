//
//  DataSourceAvailabilityTableTests.swift
//  TreeSapIOSUITests
//
//  Created by Josiah Brett on 6/12/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest

// This test class is outdated and may not work because of changes to the app
class DataSourceAvailabilityTableTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()

        let settingsButton = app.navigationBars["Home"].children(matching: .button).element(boundBy: 1)
        let exists = NSPredicate(format: "exists == 1")
        let settingsExpectation = expectation(for: exists, evaluatedWith: settingsButton, handler: nil)
        wait(for: [settingsExpectation], timeout: 8)
        settingsButton.tap()

        let tablesQuery = app.tables
        tablesQuery.staticTexts["Active data sources"].tap()
    }

    func testBackButton() {
        app.navigationBars["Active Data Sources"].buttons["Settings"].tap()
    }

    func testTextField() {
        let tablesQuery = app.tables

        let cityOfHollandButton = tablesQuery.staticTexts["City of Holland Tree Inventory"]
        let hopeCollegeButton = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hope College i-Tree Data"]/*[[".cells.staticTexts[\"Hope College i-Tree Data\"]",".staticTexts[\"Hope College i-Tree Data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let iTreeButton = tablesQuery.staticTexts["Hope College Trees"]
        let treeBenefitButton = tablesQuery.staticTexts["Tree Benefit Data"]

        cityOfHollandButton.tap()
        hopeCollegeButton.tap()
        iTreeButton.tap()
        treeBenefitButton.tap()

        cityOfHollandButton.tap()
        hopeCollegeButton.tap()
        iTreeButton.tap()
        treeBenefitButton.tap()
    }
}
