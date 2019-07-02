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

    /// The data source's name to be displayed for the user.
    let dataSourceName: String
    /// An array of Tree objects collected by this data source.
    var trees: [Tree]

    // MARK: - Initializers

    init(dataSourceName: String) {
        self.dataSourceName = dataSourceName
        trees = [Tree]()
    }

    // MARK: - Accessors

    func getTreeList() -> [Tree] {
        return trees
    }

    // MARK: - Mutators

    func importOnlineTreeData() {}
}
