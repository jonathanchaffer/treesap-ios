//
//  CSVFormat.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

enum CSVFormat {
	case holland, itree, hope
    
    func idIndex() -> Int {
        switch self {
        case .holland:
            return 0
        case .itree:
            return 0
        case .hope:
            return 0
        }
    }
	
	func commonNameIndex() -> Int {
		switch self {
		case .holland:
			return 1
		case .itree:
			return 2
		case .hope:
			return 2
		}
	}
	
	func scientificNameIndex() -> Int {
		switch self {
		case .holland:
			return 2
		case .itree:
			return 1
		case .hope:
			return 1
		}
	}
	
	func latitudeIndex() -> Int {
		switch self {
		case .holland:
			return 15
		case .itree:
			return 4
		case .hope:
			return 4
		}
	}
	
	func longitudeIndex() -> Int {
		switch self {
		case .holland:
			return 16
		case .itree:
			return 5
		case .hope:
			return 5
		}
	}
    
    func dbhIndex() -> Int {
        switch self {
        case .holland:
            return 3
        case .itree:
            return 10
        case .hope:
            return 10
        }
    }
}
