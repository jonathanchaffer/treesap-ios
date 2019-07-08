//
//  StringConstants.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and modified by Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

class StringConstants {
    // MARK: - Alerts

    static let ok = "OK"
    static let cancel = "Cancel"
    static let pleaseWait = "Please wait..."
    
    static let generalErrorTitle = "Error"
    static let generalErrorMessage = "Something went wrong. Please try again."

    static let locationUnvailableTitle = "Location could not be accessed"
    static let locationUnvailableMessage = "Please ensure that location services are enabled."

    static let noTreesFoundByGPSTitle = "No trees found"
    static let noTreesFoundByGPSMessage = "There were no trees found near your current location. You can update the identification distance in Settings."

    static let invalidCoordinatesTitle = "Invalid coordinates"
    static let invalidCoordinatesMessage = "Please ensure that you input valid coordinates."

    static let coordinatesOutOfRangeTitle = "Coordinates outside of valid range"
    static let coordinatesOutOfRangeMessage = "Please ensure that latitude is between -90 and 90, and that longitude is between -180 and 180."

    static let noTreesFoundByCoordinatesTitle = "No trees found"
    static let noTreesFoundByCoordinatesMessage = "There were no trees found near the location you inputted. You can update the identification distance in Settings."

    static let noCameraFoundTitle = "No camera found"
    static let noCameraFoundMessage = "No camera is available for use on your device."

    static let noCameraAccessTitle = "QR code scanning unavailable"
    static let noCameraAccessMessage = "Please ensure that this app has access to your camera."

    static let invalidQRCodeTitle = "Invalid QR code"
    static let invalidQRCodeMessage = "The scanned QR code is not a valid QR code for a tree."

    static let scanErrorTitle = "Scan error"
    static let scanErrorMessage = "The QR code could not be scanned."

    static let dataSourceDisabledTitle = "Data source disabled"
    static let dataSourceDisabledMessage0 = "The data source that contains the data for this tree is currently turned off. You can turn on \""
    static let dataSourceDisabledMessage1 = "\" in Settings."

    static let noTreesFoundByQRCodeTitle = "No trees found"
    static let noTreesFoundByQRCodeMessage = "No tree with the scanned QR code was found."

    static let invalidDistanceTitle = "Invalid distance"
    static let invalidDistanceMessage0 = "The max identification distance has been reset to "
    static let invalidDistanceMessage1 = "."

    static let failedToLoadNotificationsTitle = "Failed to load notifications"
    static let failedToLoadNotificationsMessage = "An error occurred while trying to load notifications. Please try again."

    static let failedToDeleteNotificationsTitle = "Failed to delete notifications"
    static let failedToDeleteNotificationsMessage = "An error occurred while trying to delete notifications. Please try again."

    static let confirmDeleteNotificationsTitle = "Remove notifications?"
    static let confirmDeleteNotificationsMessage = "The selected notifications will be permanently removed."
    static let confirmDeleteNotificationsDeleteAction = "Remove"

    static let failedToLoadPendingTreesTitle = "Failed to load pending trees"
    static let failedToLoadPendingTreesMessage = "An error occurred while trying to load pending trees. Please try again."

    static let treeUpdateSuccessTitle = "Success!"
    static let treeUpdateSuccessMessage = "The tree has been updated."

    static let treeUpdateFailureTitle = "Error updating tree"
    static let treeUpdateFailureMessage = "An error occurred while trying to update the tree. Please try again."

    static let treeRemovalSuccessTitle = "Success!"
    static let treeRemovalSuccessMessage = "The tree has been removed."

    static let treeRemovalFailureTitle = "Error removing tree"
    static let treeRemovalFailureMessage = "An error occurred while trying to remove the tree. Please try again."

    static let addMessagePromptTitle = "Add message?"
    static let addMessagePromptMessage = "Would you like to send a message to the user who submitted this tree?"
    static let addMessagePromptAddMessageAction = "Add message"
    static let addMessagePromptAcceptWithoutMessageAction = "Accept without message"
    static let addMessagePromptRejectWithoutMessageAction = "Reject without message"

    static let confirmAcceptTreeTitle = "Accept tree?"
    static let confirmAcceptTreeMessage = "This tree will be added to the online database for everyone to see."
    static let confirmAcceptTreeAcceptAction = "Accept"

    static let confirmRejectTreeTitle = "Reject tree?"
    static let confirmRejectTreeMessage = "This tree will be permanently removed from the database."
    static let confirmRejectTreeRejectAction = "Reject"

    static let confirmLogOutTitle = "Log out?"
    static let confirmLogOutMessage = "Are you sure you want to log out?"
    static let confirmLogOutLogOutAction = "Log out"

    static let failedToLogOutTitle = "Error logging out"
    static let failedToLogOutMessage = "An error occurred while trying to log out. Please try again."

    static let unmatchingPasswordsTitle = "Passwords do not match"
    static let unmatchingPasswordsMessage = "Please ensure that you entered the same password in both password fields."

    static let passwordResetSentTitle = "Password reset email sent"
    static let passwordResetSentMessage = "A password reset email was successfully sent. Please check your inbox."

    static let loginRequiredTitle = "Login required"
    static let loginRequiredMessage = "You must log into your TreeSap account to use this feature."
    static let loginRequiredLogInAction = "Log in"

    static let submitTreeSuccessTitle = "Success!"
    static let submitTreeSuccessMessage = "Your tree has been submitted for approval. While you wait, your tree will be available in the \"My Pending Trees\" data set on your device."

    static let submitTreeFailureTitle = "Error submitting trees"
    static let submitTreeFailureMessage = "An error occurred while trying to submit your tree. Please try again."

    static let addPhotoPromptCameraAction = "Take photo"
    static let addPhotoPromptGalleryAction = "Choose photo"

    static let confirmSubmitTreeTitle = "Submit tree for approval?"
    static let confirmSubmitTreeMessage = "Your tree will be added to the online tree database for everyone to see if it is approved."
    static let confirmSubmitTreeSubmitAction = "Submit"

    static let dbhExplanationTitle = "What does DBH mean?"
    static let dbhExplanationWithCircumferenceMessage = "DBH is an acronym for Diameter at Breast Height, where breast height is 4.5 feet above the ground. If you update this field, the circumference field will update automatically, and vice versa."
    static let dbhExplanationWithMultipleMessage = "DBH is an acronym for Diameter at Breast Height, where breast height is 4.5 feet above the ground. If multiple numbers are listed, it means that the tree branches below breast height."

    static let maxTrunkMeasurementsTitle = "Maximum number of trunk measurements reached"
    static let maxTrunkMeasurementsMessage0 = "You can only input up to "
    static let maxTrunkMeasurementsMessage1 = " trunk measurements."

    static let minTrunkMeasurementsTitle = "Minimum number of trunk measurements reached"
    static let minTrunkMeasurementsMessage = "At least one trunk measurement is needed."

    static let onlineDataUnavailableTitle = "Online tree data unavailable"
    static let onlineDataUnavailableMessage = "Some or all of the online tree data could not be loaded. The tree data stored on your device will be used instead."

    static let localDataUnavailableTitle = "Tree data unavailable"
    static let localDataUnavailableMessage = "Some or all of the tree data could not be loaded. Please ensure that your device is connected to the Internet and then restart the app."

    static let invalidEmailTitle = "Invalid email"
    static let invalidEmailMesage = "Please ensure that you have entered a valid email address."

    static let emailAlreadyInUseTitle = "Email already in use"
    static let emailAlreadyInUseMessage = "An account has already been created with that email."

    static let weakPasswordTitle = "Weak password"
    static let weakPasswordMessage = "Please ensure that your password contains at least 6 characters."

    static let createAccountFailureTitle = "Error creating account"
    static let createAccountFailureMessage = "An error occurred while trying to create your account. Please try again."

    static let incorrectPasswordTitle = "Incorrect password"
    static let incorrectPasswordMessage = "The password you entered was incorrect. Please try again."

    static let incorrectOldPasswordTitle = "Incorrect old password"
    static let incorrectOldPasswordMessage = "The old password you entered was incorrect. Please try again."

    static let userNotFoundTitle = "User not found"
    static let userNotFoundMessage = "A user with the email you entered was not found in the database. Please try again."

    static let loginFailureTitle = "Error logging in"
    static let loginFailureMessage = "An error occurred while trying to log into your account. Please try again."

    static let setDisplayNameFailureTitle = "Error setting display name"
    static let setDisplayNameFailureMessage = "An error occurred while trying to set your display name. Please try again."

    static let updateEmailFailureTitle = "Error updating email"
    static let updateEmailFailureMessage = "An error occurred while trying to update your email. Please try again."

    static let updatePasswordFailureTitle = "Error updating password"
    static let updatePasswordFailureMessage = "An error occurred while trying to update your password. Please try again."

    static let sendPasswordResetFailureTitle = "Error sending password reset email"
    static let sendPassowrdResetFailureMessage = "An error occurred while trying to send a password reset email. Please try again."

    static let errorComposingEmailTitle = "Error composing email"
    static let errorComposingEmailMessage = "An error occurred while trying to compose an email. Please try again or email feedback@treesap.info."

    static let feedbackSentTitle = "Feedback sent"
    static let feedbackSentMessage = "Thank you for your feedback!"
    
    static let addCuratorFailureTitle = "Error adding curator"
    static let addCuratorFailureMessage = "An error occurred while trying to add a curator. Please ensure that you enter a valid user's email address, or ask the user to log out and log back in."
    
    static let addCuratorSuccessTitle = "Curator added"
    static let addCuratorSuccessMessage = "The user can now accept and reject user-submitted trees. Note that they may need to restart the app for this change to take effect."
    
    static let exportDataFailureTitle = "Error exporting data"
    static let exportDataFailureMessage = "An error occurred while trying to export user-submitted trees. Please try again."

    // MARK: - Notification Center

    static let loggedInNotification = "loggedIn"
    static let authenticationFailureNotification = "authenticationFailure"
    static let displayNameUpdateAttemptNotification = "displayNameUpdateAttempted"
    static let emailUpdateAttemptNotification = "emailUpdateAttempted"
    static let passwordUpdateAttemptedNotification = "passwordUpdateAttempted"
    static let passwordResetSentNotification = "passwordResetSent"
    static let submitDataFailureNotification = "submitDataFailure"
    static let submitDataSuccessNotification = "submitDataSuccess"
    static let updateDataFailureNotification = "updateDataFailure"
    static let updateDataSuccessNotification = "updateDataSuccess"
    static let deleteDataFailureNotification = "deleteDataFailure"
    static let deleteDataSuccessNotification = "deleteDataSuccess"
    static let firebaseDataRetrievalFailureNotification = "firebaseDataFailed"
    static let firebaseDataRetrievalSuccessNotification = "firebaseDataRetrieved"
    static let addTreeNextPageNotification = "addTreeNext"
    static let addTreePreviousPageNotification = "addTreePrevious"
    static let submitTreeNotification = "submitTree"
    static let addCuratorFailureNotification = "addCuratorFailed"
    static let unreadNotificationsCountNotification = "unreadNotificationsCount"
}
