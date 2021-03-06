//
//  HomeViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class HomeViewController: NotificaionBadgeViewController {
    // MARK: - Properties

    @IBOutlet var addTreeDescriptionLabel: UILabel!
    @IBOutlet var settingsDescriptionLabel: UILabel!
    
    var initialized: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !initialized {
            DataManager.importAllLocalTreeData()
            DataManager.importAllOnlineTreeData()
            NetworkManager.setup()
            initialized = true
        }
        
        // Set add tree description
        let addTreeDescription = NSMutableAttributedString(string: "Use the ")
        let plusAttachment = NSTextAttachment()
        plusAttachment.image = imageWithImage(image: UIImage(named: "plus")!, scaledToSize: CGSize(width: 17, height: 17))
        plusAttachment.bounds = CGRect(x: 0.0, y: addTreeDescriptionLabel.font.descender, width: plusAttachment.image!.size.width, height: plusAttachment.image!.size.height)
        addTreeDescription.append(NSAttributedString(attachment: plusAttachment))
        addTreeDescription.append(NSAttributedString(string: " button to add your own trees."))
        addTreeDescriptionLabel.attributedText = addTreeDescription

        // Set settings description
        let settingsDescription = NSMutableAttributedString(string: "Use the ")
        let settingsAttachment = NSTextAttachment()
        settingsAttachment.image = imageWithImage(image: UIImage(named: "menu")!, scaledToSize: CGSize(width: 17, height: 17))
        settingsAttachment.bounds = CGRect(x: 0.0, y: settingsDescriptionLabel.font.descender, width: plusAttachment.image!.size.width, height: settingsAttachment.image!.size.height)
        settingsDescription.append(NSAttributedString(attachment: settingsAttachment))
        settingsDescription.append(NSAttributedString(string: " button to adjust the app settings and view other options."))
        settingsDescriptionLabel.attributedText = settingsDescription
    }

    override func viewDidAppear(_: Bool) {
        configureNotificationBadge()
    }

    // MARK: - Private functions

    /// Creates an image with the specified size. Taken from https://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
    private func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
