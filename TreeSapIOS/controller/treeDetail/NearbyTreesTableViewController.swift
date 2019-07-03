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
    var currentTree: Tree? = nil
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
        navigationController?.pushViewController(pages, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyTrees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyTreeCell", for: indexPath)
        cell.textLabel!.text = nearbyTrees[indexPath.row].commonName
        cell.detailTextLabel!.text = nearbyTrees[indexPath.row].scientificName
        return cell
    }
    
    // MARK: - Private functions
    private func closeNearbyTrees() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        closeNearbyTrees()
    }
    

}
