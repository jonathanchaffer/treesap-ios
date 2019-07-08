//
//  UserPreferenceKeysTests.swift
//  TreeSapIOSTests
//
//  Created by Josiah Brett on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

@testable import TreeSapIOS
import XCTest

class UserPreferenceTests: XCTestCase {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // Resets the state of the app so that all of the user preferences will be reset (hopefully to the default user preferences)
    override func setUp() {
        // appDelegate.resetState()
    }

    /// Tests that the user preferences are set to the default user preferences by default,
    func testStartsWithDefaults() {
        let currentCutoffDistance: Double = PreferencesManager.getCutoffDistance()
        let defaultCutoffDistance: Double = PreferencesManager.getDefaultCutoffDistance()
        XCTAssertEqual(currentCutoffDistance, defaultCutoffDistance, "The current cutoff distance of \(currentCutoffDistance) is not equal to the default cutoff distance of \(defaultCutoffDistance)")

        let currentShowUserLocation: Bool = PreferencesManager.getShowingUserLocation()
        let defaultShowUserLocation: Bool = PreferencesManager.getDefaultShowingUserLocation()
        XCTAssertEqual(currentShowUserLocation, defaultShowUserLocation, "The current setting for whether the user location is shown, \(currentShowUserLocation), is not equal to the default setting, \(defaultShowUserLocation).")

        let currentDataSourceAvailability: [String: Bool] = PreferencesManager.getDataSourceAvailability()
        let defaultDataSourceAvailability: [String: Bool] = PreferencesManager.getDefaultDataSourceAvailability()
        XCTAssertEqual(currentDataSourceAvailability, defaultDataSourceAvailability, "The current data source availibility is not the same as the default data source availibility.")
    }

    /// Tests that the AppDelegate functions that modify the user prefences, but does not test whether those modifications persist when the application is restarted.
    func testMakesImmediateChanges() {
        // Testing the cutoff distance preference
        PreferencesManager.setCutoffDistance(35.123)
        XCTAssertEqual(PreferencesManager.getCutoffDistance(), 35.123, "The cutoffDistance should have been set equal to 35.123")
        PreferencesManager.setCutoffDistance(78_999_654)
        XCTAssertEqual(PreferencesManager.getCutoffDistance(), 78_999_654, "The cutoffDistance should have been set equal to 78999654")

        // Testing the show user location preference
        let startingLocationSetting: Bool = PreferencesManager.getShowingUserLocation()
        PreferencesManager.toggleShowingUserLocation()
        let firstTestLocationSetting: Bool = PreferencesManager.getShowingUserLocation()
        XCTAssertEqual(firstTestLocationSetting, !startingLocationSetting, "Whether or not the user location is shown (\(firstTestLocationSetting) was not toggled correctly (from \(startingLocationSetting)")
        PreferencesManager.toggleShowingUserLocation()
        let secondTestLocationSetting: Bool = PreferencesManager.getShowingUserLocation()
        XCTAssertEqual(secondTestLocationSetting, !firstTestLocationSetting, "Whether or not the user location is shown (\(secondTestLocationSetting) was not toggled correctly (from \(firstTestLocationSetting)")

        // Testing the available data sources preference
        for (name, _) in PreferencesManager.getDataSourceAvailability() {
            PreferencesManager.activateDataSource(dataSourceName: name)
            XCTAssertEqual(PreferencesManager.isActive(dataSourceName: name), true, "Data source \"\(name)\" was not activated.")
        }
        for (name, _) in PreferencesManager.getDataSourceAvailability() {
            PreferencesManager.deactivateDataSource(dataSourceName: name)
            XCTAssertEqual(PreferencesManager.isActive(dataSourceName: name), false, "Data source \"\(name)\" was not deactivated.")
        }
    }

    // Tests that the user preferences. Assumes that the AppDelegate class's user preference modification and access and default preference access functions work properly/
    func testRestoreDefaults() {
        // Sets the user prefences to something other than the default user preferences
        if PreferencesManager.getShowingUserLocation() == PreferencesManager.getShowingUserLocation() {
            PreferencesManager.toggleShowingUserLocation()
        }
        for (name, availibility) in PreferencesManager.getDataSourceAvailability() {
            if availibility {
                PreferencesManager.activateDataSource(dataSourceName: name)
            } else {
                PreferencesManager.deactivateDataSource(dataSourceName: name)
            }
        }
        PreferencesManager.setCutoffDistance(PreferencesManager.getDefaultCutoffDistance() + 10)

        PreferencesManager.restoreDefaults()

        // Check whether the current user preferences match the default user preferences
        XCTAssertEqual(PreferencesManager.getShowingUserLocation(), PreferencesManager.getDefaultShowingUserLocation(), "Whether or not the user's location is shown should match the default setting (default setting: \(PreferencesManager.getDefaultDataSourceAvailability())")
        XCTAssertEqual(PreferencesManager.getDefaultCutoffDistance(), PreferencesManager.getDefaultCutoffDistance(), "The cutoff distance of \(PreferencesManager.getDefaultCutoffDistance())) does not match the default cutoff distance of \(PreferencesManager.getCutoffDistance())")
        XCTAssertEqual(PreferencesManager.getDataSourceAvailability(), PreferencesManager.getDataSourceAvailability(), "The data source availibility does not match the default data source availiblity.")
    }

    // TODO: Check that preferences persist
}
