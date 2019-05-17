//
//  DataSource.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/17/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

class DataSource {
    let internetFilebase: String = "https://faculty.hope.edu/jipping/treesap/"
    let internetFilename: String
    
    init(internetFilename: String) {
        self.internetFilename = internetFilename
    }
    
    func printData() {
        let url = URL(string: self.internetFilebase + self.internetFilename)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error")
                    return
                }
                let csvData = String(bytes: data!, encoding: String.Encoding.utf8)
                print("CSV data:")
                print(csvData!)
            }
        }
        task.resume()
    }
}
