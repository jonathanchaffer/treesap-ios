//
//  MoreInformationTests.swift
//  TreeSapIOSUITests
//
//  Created by Research on 6/19/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
import UIKit

class MoreInformationTests: XCTestCase {
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
        tablesQuery.staticTexts["More information"].tap()
    }
    
    func testITreeLink(){
        app.scrollViews.otherElements.buttons["i-Tree Link"].tap()
    }
    
    func testINaturalistLink(){
        app.scrollViews.otherElements.buttons["iNaturalist Link"].tap()
    }
    
    func testNationalTreeBenefitCalculator(){
        app.scrollViews.otherElements.buttons["National Tree Benefit Calculator Link"].tap()
    }
}
