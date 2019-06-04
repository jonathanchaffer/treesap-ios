//
//  FilledButton.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class FilledButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        self.layer.cornerRadius = 8.0
        self.layer.backgroundColor = UIColor(red: 0.452, green: 0.710, blue: 0.350, alpha: 0.15).cgColor
    }

}