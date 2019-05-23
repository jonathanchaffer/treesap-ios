//
//  SettingsViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var locationToggleSwitch: UISwitch!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        locationToggleSwitch.isOn = appDelegate.showingUserLocation
    }
    
    // MARK: Actions
    @IBAction func closeSettings(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleLocationOnMap(_ sender: UISwitch) {
        appDelegate.toggleLocationOnMap()
    }
    
}
