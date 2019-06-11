//
//  TreeDetailPageViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Used https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/ as a reference.

import CSVImporter
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

        // Set the displayed tree for each of the tree detail views.
        for page in pages {
            page.displayedTree = displayedTree
        }

        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_: Bool) {
        // Hide the tab bar when the detail display will appear.
        //tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        // Show the tab bar when the detail display will disappear.
        //tabBarController?.tabBar.isHidden = false
    }

    override func viewDidDisappear(_: Bool) {
        // Pop the tree details
        navigationController?.popViewController(animated: false)
        dismiss(animated: false, completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted _: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        pageControl!.currentPage = pages.firstIndex(of: pageContentViewController as! TreeDisplayViewController)!
    }

    // MARK: - Private methods

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
        pageControl!.currentPageIndicatorTintColor = UIColor(red: 0.373, green: 0.718, blue: 0.306, alpha: 1.0)
        pageControl!.pageIndicatorTintColor = UIColor(red: 0.373, green: 0.718, blue: 0.306, alpha: 0.3)
        view.addSubview(pageControl!)
    }

//    private func configureBenefitsByLocation() {
//        // Create a file manager and get the path for the local file
//        let fileManager = FileManager.default
//        let documentsURL = try! fileManager.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        let filepath = documentsURL.appendingPathComponent("katelyn.csv").path
//        // Create an importer for the local file
//        let importer = CSVImporter<[String]>(path: filepath)
//        let importedRecords = importer.importRecords { $0 }
//        for record in importedRecords {
//            // Check whether latitude and longitude match to 4 decimal places
//            let recordLatitude = Double(record[CSVFormat.benefits.latitudeIndex()])
//            let recordLongitude = Double(record[CSVFormat.benefits.longitudeIndex()])
//            if (recordLatitude != nil && recordLongitude != nil) {
//                print("lat: " + String(format:"%.4f", recordLatitude!))
//                print("long:" + String(format:"%.4f", recordLongitude!))
//                if (String(format:"%.4f", recordLatitude!) == String(format:"%.4f", self.displayedTree!.location.latitude)) {
//                    if (String(format:"%.4f", recordLongitude!) == String(format: "%.4f", self.displayedTree!.location.longitude)) {
//                        for page in self.pages {
//                            page.foundBenefitData = true
//                            page.totalAnnualBenefits = Double(record[CSVFormat.benefits.totalAnnualBenefitsIndex()])
//                            page.avoidedRunoffValue = Double(record[CSVFormat.benefits.avoidedRunoffValueIndex()])
//                            page.pollutionValue = Double(record[CSVFormat.benefits.pollutionValueIndex()])
//                            page.totalEnergySavings = Double(record[CSVFormat.benefits.totalEnergySavingsIndex()])
//                        }
//                    }
//                }
//            }
//        }
//    }
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

extension TreeDetailPageViewController: UIPageViewControllerDelegate {}
