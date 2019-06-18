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
        NotificationCenter.default.addObserver(self, selector: #selector(nextPage), name: NSNotification.Name("next"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(previousPage), name: NSNotification.Name("previous"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submitTree), name: NSNotification.Name("submitTree"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submitTreeSuccess), name: NSNotification.Name("submitTreeSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submitTreeFailure), name: NSNotification.Name("submitTreeFailure"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Prompt the user to log in if they're not already
        if !AccountManager.isLoggedIn() {
            let alert = UIAlertController(title: "Login required", message: "You must log into your TreeSap account to add your own trees.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.closeAddTree() }))
            alert.addAction(UIAlertAction(title: "Log In", style: .default, handler: { _ in self.goToLogin() }))
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
            dbh: Double((pages[4] as! AddTreeOtherViewController).dbhTextField.text!),
            userID: AccountManager.getUserID()
        )
        // Add the images, if any, to the Tree
        let barkImage = (pages[1] as! AddTreePhotoViewController).selectedImage
        let leafImage = (pages[2] as! AddTreePhotoViewController).selectedImage
        let entireImage = (pages[3] as! AddTreePhotoViewController).selectedImage
        if entireImage != nil {
            createdTree.addImage(entireImage!)
        }
        if leafImage != nil {
            createdTree.addImage(leafImage!)
        }
        if barkImage != nil {
            createdTree.addImage(barkImage!)
        }
        // Add the tree to the pending trees database
        DatabaseManager.addTreeToPending(tree: createdTree)
        // Display a "Please Wait" alert while it's trying to upload
        let loadingAlert = UIAlertController(title: "Please wait...", message: nil, preferredStyle: .alert)
        present(loadingAlert, animated: true)
    }
    
    /// Dismisses the loading alert, and then alerts the user that the tree was successfully submitted.
    @objc private func submitTreeSuccess() {
        dismiss(animated: true) {
            DataManager.reloadFirebaseTreeData()
            let alert = UIAlertController(title: "Success!", message: "Your tree has been submitted for approval. While you wait, your tree will be available in the \"My Pending Trees\" data set on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.closeAddTree() }))
            self.present(alert, animated: true)
        }
    }
    
    /// Dismisses the loading alert, and then alerts the user that there was an error submitting the tree.
    @objc private func submitTreeFailure() {
        dismiss(animated: true) {
            AlertManager.alertUser(title: "Error submitting tree", message: "An error occurred while trying to submit your tree. Please try again.")
        }
    }
}
