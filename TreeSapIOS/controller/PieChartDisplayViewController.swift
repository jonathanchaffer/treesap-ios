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
        
        // Configure the pie chart
        chartView.delegate = self
        chartView.drawHoleEnabled = true
        chartView.holeRadiusPercent = 0.33
        chartView.transparentCircleRadiusPercent = 0
        chartView.rotationEnabled = true
        chartView.rotationWithTwoFingers = true
        let legend = chartView.legend
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.font = .systemFont(ofSize: 17, weight: .regular)
        chartView.noDataText = "A pie chart could not be displayed for this tree."
        chartView.noDataFont = .systemFont(ofSize: 17, weight: .regular)
        chartView.noDataTextColor = .black
        chartView.noDataTextAlignment = .center
        self.updateChartData()
        chartView.animate(yAxisDuration: 1, easingOption: .easeOutBounce)
        
//        // Set the total annual benefits label
//        if (self.displayedTree!.otherInfo["totalAnnualBenefitsDollars"] != nil) {
//            self.totalAnnualBenefitsLabel.text = "$" + String(format: "%.2f", self.displayedTree!.otherInfo["totalAnnualBenefitsDollars"]!)
//        }
    }
    
    // MARK: - Private methods
    private func updateChartData() {
        // Initialize data entries
        var entries: [PieChartDataEntry] = []
        if (self.displayedTree!.otherInfo["rainfallDollars"] != nil && self.displayedTree!.otherInfo["rainfallDollars"]! > 0) {
            entries.append(PieChartDataEntry(value: self.displayedTree!.otherInfo["rainfallDollars"]!, label: "Rainwater"))
        }
        if (self.displayedTree!.otherInfo["pollutionDollars"] != nil && self.displayedTree!.otherInfo["pollutionDollars"]! > 0) {
            entries.append(PieChartDataEntry(value: self.displayedTree!.otherInfo["pollutionDollars"]!, label: "Air Quality"))
        }
        if (self.displayedTree!.otherInfo["co2Dollars"] != nil && self.displayedTree!.otherInfo["co2Dollars"]! > 0) {
            entries.append(PieChartDataEntry(value: self.displayedTree!.otherInfo["co2Dollars"]!, label: "CO2"))
        }
        if (self.displayedTree!.otherInfo["energySavingsDollars"] != nil && self.displayedTree!.otherInfo["energySavingsDollars"]! > 0) {
            entries.append(PieChartDataEntry(value: self.displayedTree!.otherInfo["energySavingsDollars"]!, label: "Energy"))
        }
        
        // Uncomment the following to use dummy data
        //        entries: [PieChartDataEntry] = []
        //        for _ in 0..<10 {
        //            entries.append(PieChartDataEntry(value: 1, label: "Test"))
        //        }
        
        // Create a data set for the entries
        let set = PieChartDataSet(values: entries, label: "")
        
        // Configure the data set
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        // Add colors to the data set
        set.colors = []
        set.colors.append(UIColor(red: 95/255, green: 184/255, blue: 78/255, alpha: 1.0))
        set.colors.append(UIColor(red: 190/255, green: 223/255, blue: 192/255, alpha: 1.0))
        set.colors.append(UIColor(red: 33/255, green: 104/255, blue: 105/255, alpha: 1.0))
        set.colors.append(UIColor(red: 134/255, green: 201/255, blue: 142/255, alpha: 1.0))
        set.colors.append(UIColor(red: 56/255, green: 85/255, blue: 81/255, alpha: 1.0))
        
        // Create and configure the pie chart data
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
