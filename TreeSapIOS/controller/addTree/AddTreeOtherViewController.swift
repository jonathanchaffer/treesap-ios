//
//  AddTreeOtherViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AddTreeOtherViewController: AddTreeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    
    @IBAction func handleDoneButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Submit tree for approval?", message: "Your tree will be added to the online tree database if it is approved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.submitTree()}))
        present(alert, animated: true)
    }
    
    // MARK: - Private methods
    
    private func submitTree() {
        let alert = UIAlertController(title: "Success!", message: "Your tree has been submitted for approval. While you wait, your tree will be available in the \"My Trees\" data set on your device.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in self.broadcastAddTreeDone()}))
        present(alert, animated: true)
    }
    
    private func broadcastAddTreeDone() {
        NotificationCenter.default.post(name: NSNotification.Name("addTreeDone"), object: nil)
    }
}
