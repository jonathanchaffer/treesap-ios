//
//  AddTreePageViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
import UIKit

class AddTreePageViewController: UIPageViewController {
    // MARK: - Properties
    
    /// The pages to be displayed in the page view.
    fileprivate lazy var pages: [AddTreeViewController] = {
        [
            self.getViewController(withIdentifier: "addTreeLocation"),
            self.getViewController(withIdentifier: "addTreeBarkPhoto"),
            self.getViewController(withIdentifier: "addTreeLeafPhoto"),
            self.getViewController(withIdentifier: "addTreeEntirePhoto"),
            self.getViewController(withIdentifier: "addTreeOtherInfo"),
        ]
    }()
    
    /// The current page number.
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the background color to white so it is not noticed when flipping quickly between the different pages
        view.backgroundColor = UIColor.white
        
        // Set the page to be displayed
        setViewControllers([pages[currentPage]], direction: .forward, animated: true, completion: nil)
        
        // Create listeners for page events
        NotificationCenter.default.addObserver(self, selector: #selector(nextPage), name: NSNotification.Name(StringConstants.addTreeNextPageNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(previousPage), name: NSNotification.Name(StringConstants.addTreePreviousPageNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submitTree), name: NSNotification.Name(StringConstants.submitTreeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submitDataSuccess), name: NSNotification.Name(StringConstants.submitDataSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submitDataFailure), name: NSNotification.Name(StringConstants.submitDataFailureNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Prompt the user to log in if they're not already
        if !AccountManager.isLoggedIn() {
            let alert = UIAlertController(title: StringConstants.loginRequiredTitle, message: StringConstants.loginRequiredMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: { _ in self.closeAddTree() }))
            alert.addAction(UIAlertAction(title: StringConstants.loginRequiredLogInAction, style: .default, handler: { _ in self.goToLogin() }))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func closeAddTreeButton(_: UIBarButtonItem) {
        closeAddTree()
    }
    
    // MARK: - Private functions
    
    /**
     Instantiates and returns a UIViewController based on the identifier of the view controller in the storyboard.
     - Parameter identifier: The storyboard ID of the view controller that is to be instantiated and returned.
     */
    private func getViewController(withIdentifier identifier: String) -> AddTreeViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! AddTreeViewController
    }
    
    /// Goes to the next page in the add tree workflow.
    @objc private func nextPage() {
        currentPage += 1
        if currentPage >= pages.count {
            currentPage = pages.count - 1
        }
        // Set the page to be displayed
        setViewControllers([pages[currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    /// Goes to the previous page in the add tree workflow.
    @objc private func previousPage() {
        currentPage -= 1
        if currentPage < 0 {
            currentPage = 0
        }
        // Set the page to be displayed
        setViewControllers([pages[currentPage]], direction: .reverse, animated: true, completion: nil)
    }
    
    /// Closes the add tree modal.
    @objc private func closeAddTree() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    /// Pushes the login screen onto the view hierarchy.
    @objc private func goToLogin() {
        let screen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSignupScreen")
        navigationController?.pushViewController(screen, animated: true)
    }
    
    @objc private func submitTree() {
        // Create a Tree object based on the parameters inputted
        let createdTree = Tree(
            id: nil,
            commonName: NameFormatter.formatCommonName(commonName: (pages[4] as! AddTreeOtherViewController).commonNameTextField.text),
            scientificName: NameFormatter.formatScientificName(scientificName: (pages[4] as! AddTreeOtherViewController).scientificNameTextField.text),
            location: CLLocationCoordinate2D(
                latitude: Double((pages[0] as! AddTreeLocationViewController).latitudeTextField.text!)!,
                longitude: Double((pages[0] as! AddTreeLocationViewController).longitudeTextField.text!)!
            ),
            native: nil,
            userID: AccountManager.getUserID()
        )
        // Add DBH values, if any, to the Tree
        let dbh = Double((pages[4] as! AddTreeOtherViewController).dbhTextField.text!)
        if dbh != nil {
            createdTree.addDBH(convertToMetricIfNecessary(dbh!))
        }
        let dbh1 = Double((pages[4] as! AddTreeOtherViewController).dbh1TextField.text!)
        if dbh1 != nil {
            createdTree.addDBH(convertToMetricIfNecessary(dbh1!))
        }
        let dbh2 = Double((pages[4] as! AddTreeOtherViewController).dbh2TextField.text!)
        if dbh2 != nil {
            createdTree.addDBH(convertToMetricIfNecessary(dbh2!))
        }
        let dbh3 = Double((pages[4] as! AddTreeOtherViewController).dbh3TextField.text!)
        if dbh3 != nil {
            createdTree.addDBH(convertToMetricIfNecessary(dbh3!))
        }
        // Add notes, if any, to the Tree
        let notes = (pages[4] as! AddTreeOtherViewController).notesTextField.text
        if notes != nil {
            let notesList = notes!.split(separator: "\n")
            for note in notesList {
                if note != "" {
                    createdTree.addNote(note: String(note))
                }
            }
        }
        // Add the images, if any, to the Tree
        let barkImages = (pages[1] as! AddTreePhotoViewController).selectedImages
        let leafImages = (pages[2] as! AddTreePhotoViewController).selectedImages
        let entireImages = (pages[3] as! AddTreePhotoViewController).selectedImages
        if !barkImages.isEmpty {
            for image in barkImages {
                createdTree.addImage(image, toCategory: .bark)
            }
        }
        if !leafImages.isEmpty {
            for image in leafImages {
                createdTree.addImage(image, toCategory: .leaf)
            }
        }
        if !entireImages.isEmpty {
            for image in entireImages {
                createdTree.addImage(image, toCategory: .full)
            }
        }
        // Add the tree to the pending trees database
        DatabaseManager.submitTreeToPending(tree: createdTree)
        // Display a loading alert while it's trying to upload
        AlertManager.showLoadingAlert()
    }
    
    /// Dismisses the loading alert, and then alerts the user that the tree was successfully submitted.
    @objc private func submitDataSuccess() {
        dismiss(animated: true) {
            DataManager.reloadFirebaseTreeData()
            let alert = UIAlertController(title: StringConstants.submitTreeSuccessTitle, message: StringConstants.submitTreeSuccessMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default, handler: { _ in self.closeAddTree() }))
            self.present(alert, animated: true)
        }
    }
    
    /// Dismisses the loading alert, and then alerts the user that there was an error submitting the tree.
    @objc private func submitDataFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: StringConstants.submitTreeFailureTitle, message: StringConstants.submitTreeFailureMessage)
        }
    }
    
    private func convertToMetricIfNecessary(_ dbh: Double) -> Double {
        if (pages[4] as! AddTreeOtherViewController).metricSwitch.isOn {
            return dbh * 2.54
        }
        return dbh
    }
}
