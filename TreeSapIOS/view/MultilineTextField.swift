//
//  MultilineTextField.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class MultilineTextField: UITextView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        layer.borderWidth = 0.7
        layer.cornerRadius = 5
        textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    }
}
