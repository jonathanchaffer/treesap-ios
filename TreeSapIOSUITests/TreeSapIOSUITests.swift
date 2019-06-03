//
//  TreeSapIOSUITests.swift
//  TreeSapIOSUITests
//
//  Created by Summer2019 on 6/3/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
import UIKit
@testable import TreeSapIOS

class TreeSapIOSUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDown() { }

    /// Tests all tabs and screens in the app.
    func testNavigation() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        let button = tabBarsQuery.buttons["Button"]
        button.tap()
        
        let coordinatesButton = tabBarsQuery.buttons["Coordinates"]
        coordinatesButton.tap()
        
        let mapButton = tabBarsQuery.buttons["Map"]
        mapButton.tap()
        
        let qrCodeButton = tabBarsQuery.buttons["QR Code"]
        qrCodeButton.tap()
        
        let homeButton = tabBarsQuery.buttons["Home"]
        homeButton.tap()
        
        let homeNavigationBar = app.navigationBars["Home"]
        homeNavigationBar.buttons["Add"].tap()
        
        let cancelButton = app.navigationBars["Add Tree"].buttons["Cancel"]
        cancelButton.tap()
        button.tap()
        
        let buttonNavigationBar = app.navigationBars["Button"]
        buttonNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        coordinatesButton.tap()
        
        let coordinatesNavigationBar = app.navigationBars["Coordinates"]
        coordinatesNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        mapButton.tap()
        
        let mapNavigationBar = app.navigationBars["Map"]
        mapNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        qrCodeButton.tap()
        
        let qrCodeNavigationBar = app.navigationBars["QR Code"]
        qrCodeNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        homeButton.tap()
        
        let button2 = homeNavigationBar.children(matching: .button).element(boundBy: 1)
        button2.tap()
        
        let closeButton = app.navigationBars["Settings"].buttons["Close"]
        closeButton.tap()
        button.tap()
        buttonNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        coordinatesButton.tap()
        coordinatesNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        mapButton.tap()
        mapNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        qrCodeButton.tap()
        qrCodeNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        homeButton.tap()
        button2.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Active data sources"]/*[[".cells.staticTexts[\"Active data sources\"]",".staticTexts[\"Active data sources\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["TreeSapIOS.DataSourceTableView"].buttons["Settings"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["More information"]/*[[".cells.staticTexts[\"More information\"]",".staticTexts[\"More information\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["More Information"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Close"].tap()
        
    }

}
