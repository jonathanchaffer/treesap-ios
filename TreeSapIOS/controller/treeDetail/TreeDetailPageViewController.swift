//
//  TreeDetailPageViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Used https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/ as a reference.

import CSVImporter
import MapKit
import UIKit

class TreeDetailPageViewController: UIPageViewController {
    // MARK: - Properties

    /// The tree that will be displayed in the tree detail views.
    var displayedTree: Tree?
    /// The dot indicator that shows the current page.
    var pageControl: UIPageControl?
    /// The pages to be displayed in the page view.
    fileprivate lazy var pages: [TreeDisplayViewController] = {
        [
            self.getViewController(withIdentifier: "simpleDisplay"),
            self.getViewController(withIdentifier: "pieChartDisplay"),
            self.getViewController(withIdentifier: "benefitsDisplay"),
        ]
    }()
    
    var shouldHideNearbyTrees = false

    // MARK: - Constructors

    init(tree: Tree) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        displayedTree = tree
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        title = "Tree Details"
        configurePageControl()

        // Set the background color to white so it is not noticed when flipping quickly between the different tree displays
        view.backgroundColor = UIColor.white

        // Estimate benefit information for trees that don't have benefit information
        var estimatedBenefitsFound = false
        if displayedTree!.otherInfo.isEmpty {
            estimatedBenefitsFound = estimateTreeBenefits(maxDistance: 1000, maxDBHDifference: 1000)
        }

        // Set the displayed tree for each of the tree detail views.
        for page in pages {
            if page is SimpleDisplayViewController && shouldHideNearbyTrees {
                (page as! SimpleDisplayViewController).shouldHideNearbyTrees = true
            }
            page.displayedTree = displayedTree
            page.estimatedBenefitsFound = estimatedBenefitsFound
        }

        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func viewWillDisappear(_: Bool) {
        // Close tree details only if not presenting a view controller, e.g. fullscreen photos view
        if presentedViewController == nil {
            closeTreeDetails()
        }
    }

    // MARK: - Private functions

    /**
     Instantiates and returns a TreeDisplayViewController based on the identifier of the view controller in the storyboard.
     - Parameter identifier: The storyboard ID of the view controller that is to be instantiated and returned.
     */
    private func getViewController(withIdentifier identifier: String) -> TreeDisplayViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! TreeDisplayViewController
    }

    /// Sets up the dot indicator that shows the current page.
    private func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 90, width: UIScreen.main.bounds.width, height: 50))
        pageControl!.numberOfPages = pages.count
        pageControl!.currentPage = 0
        pageControl!.currentPageIndicatorTintColor = UIColor(named: "treesapGreen")!
        pageControl!.pageIndicatorTintColor = UIColor(named: "treesapGreenTranslucent")!
        view.addSubview(pageControl!)
    }

    private func estimateTreeBenefits(maxDistance: Double, maxDBHDifference: Double) -> Bool {
        var bestMatch: Tree?
        for dataSource in DataManager.dataSources {
            for tree in dataSource.getTreeList() {
                if !tree.otherInfo.isEmpty,
                    tree.commonName == displayedTree!.commonName,
                    TreeFinder.distanceBetween(from: tree.location, to: displayedTree!.location) <= maxDistance,
                    abs(tree.dbhArray.average() - displayedTree!.dbhArray.average()) <= maxDBHDifference {
                    if bestMatch != nil {
                        if TreeFinder.distanceBetween(from: tree.location, to: displayedTree!.location) <= TreeFinder.distanceBetween(from: bestMatch!.location, to: displayedTree!.location) {
                            if abs(tree.dbhArray.average() - displayedTree!.dbhArray.average()) <= abs(bestMatch!.dbhArray.average() - displayedTree!.dbhArray.average()) {
                                bestMatch = tree
                            }
                        }
                    } else {
                        bestMatch = tree
                    }
                }
            }
        }
        if bestMatch != nil {
            displayedTree!.otherInfo = bestMatch!.otherInfo
            return true
        }
        return false
    }

    @objc private func closeTreeDetails() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension TreeDetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! TreeDisplayViewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! TreeDisplayViewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
}

extension TreeDetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted _: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        pageControl!.currentPage = pages.firstIndex(of: pageContentViewController as! TreeDisplayViewController)!
    }
}
