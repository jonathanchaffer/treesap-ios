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
        chartView.drawHoleEnabled = true
        chartView.transparentCircleRadiusPercent = 0
        chartView.rotationEnabled = true
        chartView.rotationWithTwoFingers = true
        let legend = chartView.legend
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        chartView.noDataText = "A pie chart could not be displayed for this tree."
        chartView.noDataFont = .systemFont(ofSize: 17, weight: .regular)
        chartView.noDataTextColor = .black
        chartView.noDataTextAlignment = .center
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
                entries.append(PieChartDataEntry(value: self.avoidedRunoffValue!, label: "Rainwater"))
            }
            if (self.pollutionValue! >= 0) {
                entries.append(PieChartDataEntry(value: self.pollutionValue!, label: "CO2"))
            }
            if (self.totalEnergySavings! >= 0) {
                entries.append(PieChartDataEntry(value: self.totalEnergySavings!, label: "Energy"))
            }
        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = []
        set.colors.append(UIColor(red: 95/255, green: 184/255, blue: 78/255, alpha: 1.0))
        set.colors.append(UIColor(red: 33/255, green: 104/255, blue: 105/255, alpha: 1.0))
        set.colors.append(UIColor(red: 129/255, green: 196/255, blue: 137/255, alpha: 1.0))
        set.colors.append(UIColor(red: 56/255, green: 85/255, blue: 81/255, alpha: 1.0))
        
        var data: PieChartData? = nil
        if (entries != []) {
            data = PieChartData(dataSet: set)
            data!.setValueFont(.systemFont(ofSize: 17, weight: .bold))
            data!.setValueTextColor(.white)
            let dollarFormatter = NumberFormatter()
            dollarFormatter.numberStyle = .currency
            dollarFormatter.maximumFractionDigits = 2
            dollarFormatter.multiplier = 1
            dollarFormatter.currencySymbol = "$"
            data!.setValueFormatter(DefaultValueFormatter(formatter: dollarFormatter))
        }
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
}
