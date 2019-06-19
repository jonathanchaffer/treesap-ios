//
//  AccountSettingsTests.swift
//  TreeSapIOSUITests
//
//  Created by Research on 6/19/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest

class AccountSettingsTests: XCTestCase {
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
        tablesQuery.staticTexts["Account settings"].tap()
    }

    //This logs the user in to an account with the e-mail "example@example.com" and the password "thingyThingy". These tests assume the user is not logged in.
    func testLogInAndOut() {
        //Uncomment this to log out the user before the rest of the tests runs
//        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Log Out"]/*[[".cells.staticTexts[\"Log Out\"]",".staticTexts[\"Log Out\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.alerts["Are you sure?"].buttons["OK"].tap()
        
        app.tables.staticTexts["Log In"].tap()
        
        //Type in Username
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element.tap()
        app.keys["e"].tap()
        app.keys["x"].tap()
        app.keys["a"].tap()
        app.keys["m"].tap()
        app.keys["p"].tap()
        app.keys["l"].tap()
        app.keys["e"].tap()
        app.keys["@"].tap()
        app.keys["e"].tap()
        app.keys["x"].tap()
        app.keys["a"].tap()
        app.keys["m"].tap()
        app.keys["p"].tap()
        app.keys["l"].tap()
        app.keys["e"].tap()
        app.keys["."].tap()
        app.keys["c"].tap()
        app.keys["o"].tap()
        app.keys["m"].tap()
        
        //Type in password
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .secureTextField).element.tap()
        app.keys["t"].tap()
        app.keys["h"].tap()
        app.keys["i"].tap()
        app.keys["n"].tap()
        app.keys["g"].tap()
        app.keys["y"].tap()
        app.buttons["shift"].tap()
        app.keys["T"].tap()
        app.keys["h"].tap()
        app.keys["i"].tap()
        app.keys["n"].tap()
        app.keys["g"].tap()
        app.keys["y"].tap()
        
        app.buttons["Log In"].tap()
        
        //Log out
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Log Out"]/*[[".cells.staticTexts[\"Log Out\"]",".staticTexts[\"Log Out\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Are you sure?"].buttons["OK"].tap()
    }
}
