//
//  AddTreePageViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/3/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import MapKit

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

    /// The current page.
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
        NotificationCenter.default.addObserver(self, selector: #selector(addTreeDone), name: NSNotification.Name("addTreeDone"), object: nil)
    }

    // MARK: - Actions

    @IBAction func closeAddTreeButton(_: UIBarButtonItem) {
        closeAddTree()
    }

    // MARK: - Private methods

    /**
     Instantiates and returns a UIViewController based on the identifier of the view controller in the storyboard.
     - Parameter identifier: The storyboard ID of the view controller that is to be instantiated and returned.
     */
    private func getViewController(withIdentifier identifier: String) -> AddTreeViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! AddTreeViewController
    }

    @objc private func nextPage() {
        currentPage += 1
        if currentPage >= pages.count {
            currentPage = pages.count - 1
        }
        // Set the page to be displayed
        setViewControllers([pages[currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc private func previousPage() {
        currentPage -= 1
        if currentPage < 0 {
            currentPage = 0
        }
        // Set the page to be displayed
        setViewControllers([pages[currentPage]], direction: .reverse, animated: true, completion: nil)
    }
    
    private func closeAddTree() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addTreeDone() {
        // Create a Tree object based on the parameters inputted
        let createdTree = Tree(
            id: nil,
            commonName: NameFormatter.formatCommonName(commonName: (pages[4] as! AddTreeOtherViewController).commonNameTextField.text),
            scientificName: NameFormatter.formatScientificName(scientificName: (pages[4] as! AddTreeOtherViewController).scientificNameTextField.text),
            location: CLLocationCoordinate2D(
                latitude: Double((pages[0] as! AddTreeLocationViewController).latitudeLabel.text!)!,
                longitude: Double((pages[0] as! AddTreeLocationViewController).longitudeLabel.text!)!),
            dbh: nil)
        // Add the images, if any, to the Tree
        let barkImage = (pages[1] as! AddTreePhotoViewController).selectedImage
        let leafImage = (pages[2] as! AddTreePhotoViewController).selectedImage
        let entireImage = (pages[3] as! AddTreePhotoViewController).selectedImage
        if (entireImage != nil) {
            createdTree.addImage(entireImage!)
        }
        if (leafImage != nil) {
            createdTree.addImage(leafImage!)
        }
        if (barkImage != nil) {
            createdTree.addImage(barkImage!)
        }
        // TODO: Do something with the Tree
        print("Created a Tree with location (" + String(createdTree.location.latitude) + ", " + String(createdTree.location.longitude) + ")")
        print("common name " + createdTree.commonName! + ", scientific name " + createdTree.scientificName!)
        // Close the add tree workflow
        closeAddTree()
    }
    
}
