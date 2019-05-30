//
//  TreeDetailPageViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/

import UIKit
import CSVImporter

class TreeDetailPageViewController: UIPageViewController {
    // MARK: Properties
    /// The tree that will be displayed in the tree detail views.
    var displayedTree: Tree? = nil
    /// The dot indicator that shows the current page.
    var pageControl: UIPageControl?
    /// The pages to be displayed in the page view.
    fileprivate lazy var pages: [TreeDisplayViewController] = {
        return [
            self.getViewController(withIdentifier: "simpleDisplay"),
            self.getViewController(withIdentifier: "pieChartDisplay"),
            self.getViewController(withIdentifier: "benefitsDisplay")
        ]
    }()
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        self.configurePageControl()
        // TODO: Move this method call to AppDelegate
        self.retrieveOnlineBenefitData()
        
        // Set the background color to white so it is not noticed when flipping quickly between the different tree displays
        self.view.backgroundColor = UIColor.white
        
        // Set the displayed tree for each of the tree detail views.
        for page in pages {
            page.displayedTree = self.displayedTree
        }
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the tab bar when the detail display will appear.
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the tab bar when the detail display will disappear.
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl!.currentPage = pages.index(of: pageContentViewController as! TreeDisplayViewController)!
    }
    
    // MARK: Private methods
    
    /**
     Instantiates and returns a TreeDisplayViewController based on the identifier of the view controller in the storyboard.
     - Parameter identifier: the storyboard ID of the view controller that is to be instantiated and returned.
     */
    private func getViewController(withIdentifier identifier: String) -> TreeDisplayViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! TreeDisplayViewController
    }
    
    /// Sets up the dot indicator that shows the current page.
    private func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl!.numberOfPages = pages.count
        pageControl!.currentPage = 0
        pageControl!.currentPageIndicatorTintColor = UIColor(red: 0.373, green: 0.718, blue: 0.306, alpha: 1.0)
        pageControl!.pageIndicatorTintColor = UIColor(red: 0.373, green: 0.718, blue: 0.306, alpha: 0.3)
        self.view.addSubview(pageControl!)
    }
    
    // TODO: Move this method to AppDelegate
    private func retrieveOnlineBenefitData() -> Bool {
        // Flag that keeps track of whether there was an error
        var isErrorFree = true
        
        // Create a task to retrieve data from the URL
        let url = URL(string: "https://faculty.hope.edu/jipping/treesap/katelyn.csv")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error!)
                isErrorFree = false
                return
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error")
                    isErrorFree = false
                    return
                }
                // Write the data to the documents directory
                let fileManager = FileManager.default
                do {
                    let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURL = documentsURL.appendingPathComponent("katelyn.csv")
                    try data!.write(to: fileURL)
                } catch {
                    print(error)
                    isErrorFree = false
                    return
                }
                // Set benefit information
                DispatchQueue.main.async {
                    self.configureBenefits()
                }
            }
        }
        // Start the task
        task.resume()
        return isErrorFree
    }
    
    private func configureBenefits() {
        // Create a file manager and get the path for the local file
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filepath = documentsURL.appendingPathComponent("katelyn.csv").path
        // Create an importer for the local file
        let importer = CSVImporter<[String]>(path: filepath)
        let importedRecords = importer.importRecords { $0 }
        for record in importedRecords {
            // Check whether latitude and longitude match to 4 decimal places
            let recordLatitude = Double(record[CSVFormat.benefits.latitudeIndex()])
            let recordLongitude = Double(record[CSVFormat.benefits.longitudeIndex()])
            if (recordLatitude != nil && recordLongitude != nil) {
                print("lat: " + String(format:"%.4f", recordLatitude!))
                print("long:" + String(format:"%.4f", recordLongitude!))
                if (String(format:"%.4f", recordLatitude!) == String(format:"%.4f", self.displayedTree!.location.latitude)) {
                    if (String(format:"%.4f", recordLongitude!) == String(format: "%.4f", self.displayedTree!.location.longitude)) {
                        for page in self.pages {
                            page.foundBenefitData = true
                            page.totalAnnualBenefits = Double(record[CSVFormat.benefits.totalAnnualBenefitsIndex()])
                            page.avoidedRunoffValue = Double(record[CSVFormat.benefits.avoidedRunoffValueIndex()])
                            page.pollutionValue = Double(record[CSVFormat.benefits.pollutionValueIndex()])
                            page.totalEnergySavings = Double(record[CSVFormat.benefits.totalEnergySavingsIndex()])
                        }
                    }
                }
            }
        }
    }
}

extension TreeDetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! TreeDisplayViewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! TreeDisplayViewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
}

extension TreeDetailPageViewController: UIPageViewControllerDelegate { }
