//
//  PendingTreesTableViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Firebase

class PendingTreesTableViewController: UITableViewController {
    // MARK: - Properties
    var PendingTreesDataSource = FirebaseDataSource(dataSourceName: "All Pending Trees", databaseType: .allPendingTrees)
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pending Trees"
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(StringConstants.firebaseDataRetrievalSuccessNotification), object: PendingTreesDataSource)
        NotificationCenter.default.addObserver(self, selector: #selector(failedToLoad), name: NSNotification.Name(StringConstants.firebaseDataRetrievalFailureNotification), object: PendingTreesDataSource)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PendingTreesDataSource.importOnlineTreeData()
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return PendingTreesDataSource.trees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingTreeCell", for: indexPath)
        // Get the data for the cell
        let tree = PendingTreesDataSource.trees[indexPath.row]
        // If there is a common name, add it
        let commonName = tree.commonName
        if commonName != nil && commonName != "" {
            cell.textLabel?.text = commonName
        } else {
            cell.textLabel?.text = "N/A"
        }
        // If there is a scientific name, add it
        let scientificName = tree.scientificName
        if scientificName != nil && scientificName != "" {
            cell.detailTextLabel?.text = scientificName
        } else {
            cell.detailTextLabel?.text = "N/A"
        }
        // If there is at least one image, display it. Prefer full tree images
        let images = tree.images
        if images[.full]!.count >= 1 {
            cell.imageView?.image = images[.full]!.first
        } else if images[.leaf]!.count >= 1 {
            cell.imageView?.image = images[.leaf]!.first
        } else if images[.bark]!.count >= 1 {
            cell.imageView?.image = images[.bark]!.first
        }
        return cell
    }
    
    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pendingTreeDetails") as! PendingTreeDetailsViewController
        vc.displayedTree = PendingTreesDataSource.trees[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Reloads the table data.
    @objc private func reloadTableData() {
        tableView.reloadData()
        reloadTableRows()
    }
    
    /// Reloads the table data.
    private func reloadTableRows() {
        var rows = [IndexPath]()
        for i in 0 ..< PendingTreesDataSource.trees.count {
            rows.append(IndexPath(row: i, section: 0))
        }
        tableView.reloadRows(at: rows, with: .automatic)
    }
    
    /// Shows an alert saying that pending trees could not be loaded.
    @objc private func failedToLoad() {
        let alert = UIAlertController(title: StringConstants.failedToLoadPendingTreesTitle, message: StringConstants.failedToLoadPendingTreesMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.ok, style: .cancel, handler: { _ in self.closePendingTrees() }))
        present(alert, animated: true)
    }
    
    /// Closes the list of pending trees.
    private func closePendingTrees() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
