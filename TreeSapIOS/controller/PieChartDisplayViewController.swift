//
//  PieChartDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import Charts

class PieChartDisplayViewController: TreeDisplayViewController, ChartViewDelegate {
    // MARK: - Properties
    @IBOutlet weak var chartView: PieChartView!

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        chartView.delegate = self
        chartView.drawHoleEnabled = false
        let legend = chartView.legend
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.font = .systemFont(ofSize: 17, weight: .regular)
        self.updateChartData()
        chartView.animate(yAxisDuration: 1, easingOption: .easeOutBounce)
    }
    
    // MARK: - Private methods
    private func updateChartData() {
        var entries: [PieChartDataEntry] = []
        if (self.foundBenefitData) {
            print(self.avoidedRunoffValue!)
            print(self.pollutionValue!)
            print(self.totalEnergySavings!)
            if (self.avoidedRunoffValue! >= 0) {
                entries.append(PieChartDataEntry(value: self.avoidedRunoffValue!, label: "Avoided Runoff"))
            }
            if (self.pollutionValue! >= 0) {
                entries.append(PieChartDataEntry(value: self.pollutionValue!, label: "Pollution"))
            }
            if (self.totalEnergySavings! >= 0) {
                entries.append(PieChartDataEntry(value: self.totalEnergySavings!, label: "Energy Savings"))
            }
        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = []
        for i in 0..<4 {
            let redOffset = CGFloat(Double(i) * -0.2)
            let greenOffset = CGFloat(Double(i) * -0.1)
            let blueOffset = CGFloat(Double(i) * 0.01)
            set.colors.append(UIColor(red: 0.373 + redOffset, green: 0.718 + greenOffset, blue: 0.306 + blueOffset, alpha: 1.0))
        }
        
        let data = PieChartData(dataSet: set)
        
        data.setValueFont(.systemFont(ofSize: 17, weight: .regular))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
}
