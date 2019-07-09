//
//  NearbyTreesTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class NearbyTreesTableViewController: UITableViewController {
    // MARK: - Properties

    var currentTree: Tree?
    var nearbyTrees = [Tree]()

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the nearby trees
        nearbyTrees = TreeFinder.findTreesByLocation(location: currentTree!.location, dataSources: PreferencesManager.getActiveDataSources(), cutoffDistance: PreferencesManager.getCutoffDistance(), maxNumTrees: 10)
        // Remove the first tree in the list, which is the current tree
        nearbyTrees.remove(at: 0)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let treeToDisplay = nearbyTrees[indexPath.row]
        let pages = TreeDetailPageViewController(tree: treeToDisplay)
        pages.shouldHideNearbyTrees = true
        navigationController?.pushViewController(pages, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return nearbyTrees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyTreeCell", for: indexPath)
        let tree = nearbyTrees[indexPath.row]
        cell.textLabel!.text = tree.commonName
        cell.detailTextLabel!.text = tree.scientificName
        // If there is at least one image, display it. Prefer leaf images
        let images = tree.images
        if images[.leaf]!.count >= 1 {
            cell.imageView?.image = images[.leaf]!.first
        } else if images[.full]!.count >= 1 {
            cell.imageView?.image = images[.full]!.first
        } else if images[.bark]!.count >= 1 {
            cell.imageView?.image = images[.bark]!.first
        }
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 72
    }

    // MARK: - Private functions

    private func closeNearbyTrees() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func closeButtonPressed(_: UIBarButtonItem) {
        closeNearbyTrees()
    }
}
