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
        return newCommonName
    }

    class func formatScientificName(scientificName: String) -> String {
        var newScientificName = scientificName
        let spaceSplit = newScientificName.split(separator: " ")
        if spaceSplit.count >= 3 {
            if spaceSplit[0].last! >= Character("0"), spaceSplit[0].last! <= Character("Z") {
                newScientificName = ""
                for i in 1 ..< spaceSplit.count - 1 {
                    newScientificName += spaceSplit[i] + " "
                }
                newScientificName += spaceSplit[spaceSplit.count - 1]
            }
        }
        return newScientificName
    }

    class func trim(_ string: Substring) -> String {
        return string.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
}
