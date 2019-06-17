//
//  DataSource.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

class DataSource {
    // MARK: - Properties
    
    /// A string representation of the data source's name, for user readability.
    let dataSourceName: String
    /// An array of Tree objects collected by this data source.
    var trees: [Tree]

    init(dataSourceName: String) {
        self.dataSourceName = dataSourceName
        trees = [Tree]()
    }

    // MARK: - Functions

    func getTreeList() -> [Tree] {
        return trees
    }

    func importOnlineTreeData() {}
    
}
