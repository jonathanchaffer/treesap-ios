//
//  NameFormatter.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

class NameFormatter {
    class func formatCommonName(commonName: String) -> String {
        var newCommonName = commonName
        if newCommonName.contains("-") {
            let hyphenSplit = newCommonName.split(separator: "-")
            newCommonName = trim(hyphenSplit[1]) + " " + trim(hyphenSplit[0])
        }
        return newCommonName;
    }
    
    class func trim(_ string: Substring) -> String {
        return string.trimmingCharacters(in: CharacterSet(charactersIn:"    "))
    }
}
