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
        // If there is a hyphen, flip the two sides and put a space in between
        if newCommonName.contains("-") {
            let hyphenSplit = newCommonName.split(separator: "-")
            newCommonName = trim(hyphenSplit[1]) + " " + trim(hyphenSplit[0])
        }
        // Capitalize each word
        let spaceSplit = newCommonName.split(separator: " ")
        newCommonName = ""
        if spaceSplit.count >= 1 {
            for i in 0 ..< spaceSplit.count - 1 {
                newCommonName += spaceSplit[i].capitalized + " "
            }
            newCommonName += spaceSplit[spaceSplit.count - 1].capitalized
        }
        // Handle special cases
        if (newCommonName == "Little Leaf Linden"){
            newCommonName = "Littleleaf Linden"
        }
        if (newCommonName == "Common Honeylocust") {
            newCommonName = "Honeylocust"
        }
        if (newCommonName == "Crimson King Maple") {
            newCommonName = "Norway Maple"
        }
        if (newCommonName == "Japanese Flowering Crabapple") {
            newCommonName = "Japanese Flower Crabapple"
        }
        if (newCommonName == "Flowering Cherry") {
            newCommonName = "Japanese Flowering Cherry"
        }
        if (newCommonName == "Colorado Blue Spruce") {
            newCommonName = "Blue Spruce"
        }
        if (newCommonName == "Eastern Redcedar") {
            newCommonName = "Eastern Red Cedar"
        }
        // Return the formatted name
        return newCommonName
    }

    class func formatScientificName(scientificName: String) -> String {
        var newScientificName = scientificName
        // If there are at least three words, check whether the first word is an abbreviation
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
        // Capitalize the first word, and lowercase the others
        let spaceSplit2 = newScientificName.split(separator: " ")
        newScientificName = ""
        if spaceSplit2.count >= 1 {
            newScientificName += spaceSplit2[0].capitalized
            if spaceSplit2.count >= 2 {
                for i in 1 ..< spaceSplit2.count {
                    newScientificName += " " + spaceSplit2[i].lowercased()
                }
            }
        }
        // Return the formatted name
        return newScientificName
    }

    /**
     Removes spaces at the beginning and end of a string.
     - Parameter string: The string to trim.
     - Returns: The trimmed string.
     */
    class func trim(_ string: Substring) -> String {
        return string.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
}
