//
//  ImageCategory.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

enum ImageCategory {
    case bark, leaf, full
    
    func toString() -> String {
        switch self {
        case .bark:
            return "bark"
        case .leaf:
            return "leaf"
        case .full:
            return "full"
        }
    }
}
