//
//  TreeDetailPageViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/

import UIKit

class TreeDetailPageViewController: UIPageViewController {
    var displayedTree: Tree? = nil
    
    fileprivate lazy var pages: [TreeDisplayViewController] = {
        return [
            self.getViewController(withIdentifier: "simpleDisplay"),
            self.getViewController(withIdentifier: "pieChartDisplay"),
            self.getViewController(withIdentifier: "benefitsDisplay")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> TreeDisplayViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! TreeDisplayViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        for page in pages {
            page.displayedTree = self.displayedTree
        }
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
