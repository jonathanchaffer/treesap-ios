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
    fileprivate lazy var pages: [UIViewController] = {
        [
            self.getViewController(withIdentifier: "addTreeLocation"),
            self.getViewController(withIdentifier: "addTreeBarkPhoto"),
            self.getViewController(withIdentifier: "addTreeLeafPhoto"),
            self.getViewController(withIdentifier: "addTreeEntirePhoto"),
            self.getViewController(withIdentifier: "addTreeOtherInfo"),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        // Set the background color to white so it is not noticed when flipping quickly between the different pages
        view.backgroundColor = UIColor.white
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK - Actions
    @IBAction func closeAddTree(_: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    /**
     Instantiates and returns a UIViewController based on the identifier of the view controller in the storyboard.
     - Parameter identifier: The storyboard ID of the view controller that is to be instantiated and returned.
     */
    private func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

}

extension AddTreePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
}
