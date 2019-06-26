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

    //This logs the user in to an account with the e-mail "example@example.com" and the password "thingyThingy". If the user is logged in at the beginning of the test, the user is logged out before the rest of the test runs.
    func testLogInAndOut() {
        //Logs the user out, if they are logged in
        let logoutButton = app.tables.staticTexts["log out"]
        if(logoutButton.exists && logoutButton.isHittable){
            logoutButton.tap()
            app.alerts["Are you sure?"].buttons["OK"].tap()
        }
        
        app.tables.staticTexts["log in or sign up"].tap()
        
        //Type in Email
        app.textFields["log in email entry"].tap()
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
        
        app.buttons["Next"].tap()
        
        //Type in password
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
        
        //Log in
        app.buttons["Go"].tap()
        
        //Log out
        app.tables.staticTexts["log out"].tap()
        app.alerts["Are you sure?"].buttons["OK"].tap()
    }
    
    func testCreateAccount(){
        
        //Logs the user out, if they are logged in
        let logoutButton = app.tables.staticTexts["log out"]
        if(logoutButton.exists && logoutButton.isHittable){
            logoutButton.tap()
            app.alerts["Are you sure?"].buttons["OK"].tap()
        }
        
        app.tables.staticTexts["log in or sign up"].tap()
        app.buttons["create an account"].tap()
        
        //Type in e-mail
        app.textFields["create account email entry"].tap()
        app.keys["t"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.buttons["shift"].tap()
        app.keys["E"].tap()
        app.keys["m"].tap()
        app.keys["a"].tap()
        app.keys["i"].tap()
        app.keys["l"].tap()
        app.keys["@"].tap()
        app.keys["t"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.buttons["shift"].tap()
        app.keys["E"].tap()
        app.keys["m"].tap()
        app.keys["a"].tap()
        app.keys["i"].tap()
        app.keys["l"].tap()
        app.keys["."].tap()
        app.keys["c"].tap()
        app.keys["o"].tap()
        app.keys["m"].tap()
        
        app.buttons["Next"].tap()
        
        //Type in password
        app.keys["t"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.buttons["shift"].tap()
        app.keys["P"].tap()
        app.keys["a"].tap()
        app.keys["s"].tap()
        app.keys["s"].tap()
        app.keys["w"].tap()
        app.keys["o"].tap()
        app.keys["r"].tap()
        app.keys["d"].tap()
        
        app.buttons["Next"].tap()
        
        //Type in password confirmation
        app.keys["t"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.buttons["shift"].tap()
        app.keys["P"].tap()
        app.keys["a"].tap()
        app.keys["s"].tap()
        app.keys["s"].tap()
        app.keys["w"].tap()
        app.keys["o"].tap()
        app.keys["r"].tap()
        app.keys["d"].tap()
        
        app.buttons["Go"].tap()
    }
}
