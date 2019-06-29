//
//  MultilineTextField.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/24/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class MultilineTextField: UITextView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        layer.borderWidth = 0.7
        layer.cornerRadius = 5
        self.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    }

}
