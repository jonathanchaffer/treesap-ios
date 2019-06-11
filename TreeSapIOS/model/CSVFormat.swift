//
//  CSVFormat.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

enum CSVFormat {
    case holland, itree, hope, benefits

    // MARK: - Basic tree information
    
    /// Returns the index for the tree ID, or -1 if there is none.
    func idIndex() -> Int {
        switch self {
        case .holland:
            return 0
        case .itree:
            return 0
        case .hope:
            return 0
        case .benefits:
            return 0
        }
    }

    /// Returns the index for the common name, or -1 if there is none.
    func commonNameIndex() -> Int {
        switch self {
        case .holland:
            return 1
        case .itree:
            return 2
        case .hope:
            return 2
        case .benefits:
            return 1
        }
    }

    /// Returns the index for the scientific name, or -1 if there is none.
    func scientificNameIndex() -> Int {
        switch self {
        case .holland:
            return 2
        case .itree:
            return 1
        case .hope:
            return 1
        case .benefits:
            return -1
        }
    }

    /// Returns the index for the latitude, or -1 if there is none.
    func latitudeIndex() -> Int {
        switch self {
        case .holland:
            return 15
        case .itree:
            return 4
        case .hope:
            return 4
        case .benefits:
            return 4
        }
    }

    /// Returns the index for the longitude, or -1 if there is none.
    func longitudeIndex() -> Int {
        switch self {
        case .holland:
            return 16
        case .itree:
            return 5
        case .hope:
            return 5
        case .benefits:
            return 3
        }
    }

    /// Returns the index for the DBH, or -1 if there is none.
    func dbhIndex() -> Int {
        switch self {
        case .holland:
            return 3
        case .itree:
            return 10
        case .hope:
            return 10
        case .benefits:
            return 2
        }
    }
    
    // MARK: - General benefit information
    
    /// Returns the index for carbon sequestration (lbs/yr), or -1 if there is none.
    func carbonSequestrationPoundsIndex() -> Int {
        switch self {
        case .benefits:
            return 19
        default:
            return -1
        }
    }

    /// Returns the index for carbon sequestration ($/yr), or -1 if there is none.
    func carbonSequestrationDollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 20
        default:
            return -1
        }
    }
    
    /// Returns the index for avoided runoff (ft^3/yr), or -1 if there is none.
    func avoidedRunoffCubicFeetIndex() -> Int {
        switch self {
        case .benefits:
            return 21
        default:
            return -1
        }
    }

    /// Returns the index for avoided runoff ($/yr), or -1 if there is none.
    func avoidedRunoffDollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 22
        default:
            return -1
        }
    }
    
    
    /// Returns the index for carbon avoided (lbs/yr), or -1 if there is none.
    func carbonAvoidedPoundsIndex() -> Int {
        switch self {
        case .benefits:
            return 23
        default:
            return -1
        }
    }
    
    /// Returns the index for carbon avoided ($/yr), or -1 if there is none.
    func carbonAvoidedDollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 24
        default:
            return -1
        }
    }
    
    /// Returns the index for pollution removal (oz/yr), or -1 if there is none.
    func pollutionRemovalOuncesIndex() -> Int {
        switch self {
        case .benefits:
            return 25
        default:
            return -1
        }
    }

    /// Returns the index for pollution removal ($/yr), or -1 if there is none.
    func pollutionRemovalDollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 26
        default:
            return -1
        }
    }

    /// Returns the index for energy savings ($/yr), or -1 if there is none.
    func energySavingsDollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 27
        default:
            return -1
        }
    }

    /// Returns the index for total annual benefits ($/yr), or -1 if there is none.
    func totalAnnualBenefitsDollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 28
        default:
            return -1
        }
    }
    
    // MARK: - Breakdown benefit information
    
    /// Returns the index for CO ($/yr), or -1 if there is none.
    func coDollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 41
        default:
            return -1
        }
    }
    
    /// Returns the index for O3 ($/yr), or -1 if there is none.
    func o3DollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 42
        default:
            return -1
        }
    }
    
    /// Returns the index for NO2 ($/yr), or -1 if there is none.
    func no2DollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 43
        default:
            return -1
        }
    }
    
    /// Returns the index for SO2 ($/yr), or -1 if there is none.
    func so2DollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 44
        default:
            return -1
        }
    }
    
    /// Returns the index for PM2.5 ($/yr), or -1 if there is none.
    func pm25DollarsIndex() -> Int {
        switch self {
        case .benefits:
            return 45
        default:
            return -1
        }
    }
}
