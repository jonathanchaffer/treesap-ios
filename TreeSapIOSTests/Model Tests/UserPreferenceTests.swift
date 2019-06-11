//
//  UserPreferenceKeysTests.swift
//  TreeSapIOSTests
//
//  Created by Research on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
@testable import TreeSapIOS

class UserPreferenceTests: XCTestCase {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //Resets the state of the app so that all of the user preferences will be reset (hopefully to the default user preferences)
    override func setUp() {
        //appDelegate.resetState()
    }
    
    ///Tests that the user preferences are set to the default user preferences by default,
    func testStartsWithDefaults(){
        let currentCutoffDistance: Double = appDelegate.accessCutoffDistance()
        let defaultCutoffDistance: Double = UserPreferenceKeys.cutoffDistanceDefault
        XCTAssertEqual(currentCutoffDistance, defaultCutoffDistance, "The current cutoff distance of \(currentCutoffDistance) is not equal to the default cutoff distance of \(defaultCutoffDistance)")
        
        let currentShowUserLocation: Bool = appDelegate.accessShowUserLocation()
        let defaultShowUserLocation: Bool = UserPreferenceKeys.showUserLocationDefault
        XCTAssertEqual(currentShowUserLocation, defaultShowUserLocation, "The current setting for whether the user location is shown, \(currentShowUserLocation), is not equal to the default setting, \(defaultShowUserLocation).")
        
        let currentDataSourceAvailibility: [String: Bool] = appDelegate.accessDataSourceAvailibility()
        let defaultDataSourceAvailibility: [String: Bool] = UserPreferenceKeys.dataSourceAvailibilityDefault
        XCTAssertEqual(currentDataSourceAvailibility, defaultDataSourceAvailibility, "The current data source availibility is not the same as the default data source availibility.")
    }
    
    ///Tests that the AppDelegate functions that modify the user prefences, but does not test whether those modifications persist when the application is restarted.
    func testMakesImmediateChanges(){
        //Testing the cutoff distance preference
        appDelegate.modifyCutoffDistance(cutoffDistance: 35.123)
        XCTAssertEqual(appDelegate.accessCutoffDistance(), 35.123, "The cutoffDistance should have been set equal to 35.123")
        appDelegate.modifyCutoffDistance(cutoffDistance: 78999654)
        XCTAssertEqual(appDelegate.accessCutoffDistance(), 78999654, "The cutoffDistance should have been set equal to 78999654")
        
        //Testing the show user location preference
        let startingLocationSetting: Bool = appDelegate.accessShowUserLocation()
        appDelegate.toggleShowingUserLocation()
        let firstTestLocationSetting: Bool = appDelegate.accessShowUserLocation()
        XCTAssertEqual(firstTestLocationSetting, !startingLocationSetting, "Whether or not the user location is shown (\(firstTestLocationSetting) was not toggled correctly (from \(startingLocationSetting)")
        appDelegate.toggleShowingUserLocation()
        let secondTestLocationSetting: Bool = appDelegate.accessShowUserLocation()
        XCTAssertEqual(secondTestLocationSetting, !firstTestLocationSetting, "Whether or not the user location is shown (\(secondTestLocationSetting) was not toggled correctly (from \(firstTestLocationSetting)")

        //Testing the available data sources preference
        for (name, _) in appDelegate.accessDataSourceAvailibility(){
            appDelegate.activateDataSource(dataSourceName: name)
            XCTAssertEqual(appDelegate.isActive(dataSourceName: name), true, "Data source \"\(name)\" was not activated.")
        }
        for (name, _) in appDelegate.accessDataSourceAvailibility(){
            appDelegate.deactivateDataSource(dataSourceName: name)
            XCTAssertEqual(appDelegate.isActive(dataSourceName: name), false, "Data source \"\(name)\" was not deactivated.")
        }
    }
    
    //Tests that the user preferences. Assumes that the AppDelegate class's user preference modification and access and default preference access functions work properly/
    func testRestoreDefaults(){
        //Sets the user prefences to something other than the default user preferences
        if(appDelegate.accessShowUserLocation() == appDelegate.accessShowUserLocationDefault()){
            appDelegate.toggleShowingUserLocation()
        }
        for (name, availibility) in appDelegate.accessDataSourceAvailibilityDefault(){
            if(availibility){
                appDelegate.activateDataSource(dataSourceName: name)
            }else{
                appDelegate.deactivateDataSource(dataSourceName: name)
            }
        }
        appDelegate.modifyCutoffDistance(cutoffDistance: appDelegate.accessCutoffDistanceDefault() + 10)

        appDelegate.restoreDefaultUserPreferences()
        
        //Check whether the current user preferences match the default user preferences
        XCTAssertEqual(appDelegate.accessShowUserLocation(), appDelegate.accessShowUserLocationDefault(), "Whether or not the user's location is shown should match the default setting (default setting: \(appDelegate.accessDataSourceAvailibilityDefault())")
        XCTAssertEqual(appDelegate.accessCutoffDistanceDefault(), appDelegate.accessCutoffDistanceDefault(), "The cutoff distance of \(appDelegate.accessCutoffDistanceDefault())) does not match the default cutoff distance of \(appDelegate.accessCutoffDistanceDefault())")
        XCTAssertEqual(appDelegate.accessDataSourceAvailibility(), appDelegate.accessDataSourceAvailibility(), "The data source availibility does not match the default data source availiblity.")
    }
    
    //TODO: Check that preferences persist
}
