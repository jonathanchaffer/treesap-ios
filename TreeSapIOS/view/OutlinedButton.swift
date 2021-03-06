//
//  OutlinedButton.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class OutlinedButton: UIButton {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        layer.cornerRadius = 8.0
        layer.borderWidth = 1
    }
}
