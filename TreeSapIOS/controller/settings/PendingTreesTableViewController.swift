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
    var documents = [QueryDocumentSnapshot]()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pending Trees"
        DatabaseManager.getAllPendingTreesCollection()?.getDocuments() { snapshot, error in
            if let error = error {
                print("Error retrieving documents: \(error)")
            } else {
                self.documents = snapshot!.documents
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingTreeCell", for: indexPath)
        // Get the data for the cell
        let data = documents[indexPath.row].data()
        // If there is a common name, add it
        let commonName = data["commonName"] as? String
        if commonName != nil && commonName != "" {
            cell.textLabel?.text = data["commonName"] as? String
        } else {
            cell.textLabel?.text = "N/A"
        }
        // If there is a scientific name, add it
        let scientificName = data["scientificName"] as? String
        if scientificName != nil && scientificName != "" {
            cell.detailTextLabel?.text = data["scientificName"] as? String
        } else {
            cell.detailTextLabel?.text = "N/A"
        }
        // If there is at least one image, display it
        let images = data["images"] as? [String]
        if images != nil && images!.count >= 1 {
            let decodedImageData: Data = Data(base64Encoded: images![0], options: .ignoreUnknownCharacters)!
            let decodedImage = UIImage(data: decodedImageData)
            cell.imageView?.image = decodedImage
        }
        return cell
    }
    
    /// Function that is called when a table cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
