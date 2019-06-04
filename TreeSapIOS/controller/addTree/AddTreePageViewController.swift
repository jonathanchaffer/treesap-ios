//
//  AddTreePageViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/3/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

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
        NotificationCenter.default.addObserver(self, selector: #selector(closeAddTree), name: NSNotification.Name("closeAddTree"), object: nil)
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
            currentPage = 0
        }
        // Set the page to be displayed
        setViewControllers([pages[currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc private func closeAddTree() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
