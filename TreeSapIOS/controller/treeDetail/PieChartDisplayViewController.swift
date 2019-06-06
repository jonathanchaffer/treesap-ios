//
//  PieChartDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Charts
import UIKit

class PieChartDisplayViewController: TreeDisplayViewController, ChartViewDelegate {
    // MARK: - Properties

    @IBOutlet var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: HorizontalBarChartView!
    let dollarFormatter = NumberFormatter()
    
    // Variables that keep track of the indices of data with breakdown data
    var pollutionIndex = -1
    var energySavingsIndex = -1
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the dollar formatter
        dollarFormatter.numberStyle = .currency
        dollarFormatter.maximumFractionDigits = 2
        dollarFormatter.multiplier = 1
        dollarFormatter.currencySymbol = "$"

        // Configure the pie chart
        pieChartView.delegate = self
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.33
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.rotationEnabled = true
        pieChartView.rotationWithTwoFingers = true
        let legend = pieChartView.legend
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.font = .systemFont(ofSize: 17, weight: .regular)
        pieChartView.noDataText = "A pie chart could not be displayed for this tree."
        pieChartView.noDataFont = .systemFont(ofSize: 17, weight: .regular)
        pieChartView.noDataTextColor = .black
        pieChartView.noDataTextAlignment = .center
        updatePieChartData()
        pieChartView.animate(yAxisDuration: 1, easingOption: .easeInOutCubic)
        
        // Configure the bar chart
        barChartView.delegate = self
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.highlightPerTapEnabled = false
        barChartView.highlightPerDragEnabled = false
        barChartView.noDataText = "Tap certain sections of the pie chart to view a breakdown for that section."
        barChartView.noDataFont = .systemFont(ofSize: 17, weight: .regular)
        barChartView.noDataTextColor = .black
        barChartView.noDataTextAlignment = .center
    }

    // MARK: - Private methods

    private func updatePieChartData() {
        // Initialize data entries
        var entries: [PieChartDataEntry] = []
        if displayedTree!.otherInfo["rainfallDollars"] != nil, displayedTree!.otherInfo["rainfallDollars"]! > 0 {
            let entry = PieChartDataEntry(value: displayedTree!.otherInfo["rainfallDollars"]!, label: "Rainwater")
            entry.accessibilityLabel = "rainfallDollars"
            entries.append(entry)
        }
        if displayedTree!.otherInfo["pollutionDollars"] != nil, displayedTree!.otherInfo["pollutionDollars"]! > 0 {
            let entry = PieChartDataEntry(value: displayedTree!.otherInfo["pollutionDollars"]!, label: "Air Quality")
            entry.accessibilityLabel = "pollutionDollars"
            entries.append(entry)
        }
        if displayedTree!.otherInfo["co2Dollars"] != nil, displayedTree!.otherInfo["co2Dollars"]! > 0 {
            let entry = PieChartDataEntry(value: displayedTree!.otherInfo["co2Dollars"]!, label: "CO₂")
            entry.accessibilityLabel = "co2Dollars"
            entries.append(entry)
        }
        if displayedTree!.otherInfo["energySavingsDollars"] != nil, displayedTree!.otherInfo["energySavingsDollars"]! > 0 {
            let entry = PieChartDataEntry(value: displayedTree!.otherInfo["energySavingsDollars"]!, label: "Energy")
            entry.accessibilityLabel = "energySavingsDollars"
            entries.append(entry)
        }

        // Uncomment the following to use dummy data
        //        entries: [PieChartDataEntry] = []
        //        for _ in 0..<10 {
        //            entries.append(PieChartDataEntry(value: 1, label: "Test"))
        //        }

        // Create a data set for the entries
        let set = PieChartDataSet(entries: entries, label: "")

        // Configure the data set
        set.drawIconsEnabled = false
        set.sliceSpace = 2

        // Add colors to the data set
        set.colors = []
        set.colors.append(UIColor(red: 95 / 255, green: 184 / 255, blue: 78 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 190 / 255, green: 223 / 255, blue: 192 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 33 / 255, green: 104 / 255, blue: 105 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 134 / 255, green: 201 / 255, blue: 142 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 56 / 255, green: 85 / 255, blue: 81 / 255, alpha: 1.0))

        // Create and configure the pie chart data
        var data: PieChartData?
        if entries != [] {
            data = PieChartData(dataSet: set)
            data!.setValueFont(.systemFont(ofSize: 17, weight: .bold))
            data!.setValueTextColor(.white)
            data!.setValueFormatter(DefaultValueFormatter(formatter: dollarFormatter))
        }
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
    
    private func updateBarChartData(breakdownData: BreakdownData) {
        // Initialize data entries
        var entries: [BarChartDataEntry] = []
        
        if breakdownData == .pollution {
            entries.append(BarChartDataEntry(x: 0, yValues: [1, 2, 3, 4, 5]))
        }
        else if breakdownData == .energySavings {
            entries.append(BarChartDataEntry(x: 0, yValues: [0.5, 1, 1.5, 2, 2.5]))
        }
        
        // Create a data set for the entries
        let set = BarChartDataSet(entries: entries, label: "")
        
        // Configure the data set
        set.drawIconsEnabled = false
        set.drawValuesEnabled = true
        
        // Add colors to the data set
        set.colors = []
        set.colors.append(UIColor(red: 95 / 255, green: 184 / 255, blue: 78 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 190 / 255, green: 223 / 255, blue: 192 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 33 / 255, green: 104 / 255, blue: 105 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 134 / 255, green: 201 / 255, blue: 142 / 255, alpha: 1.0))
        set.colors.append(UIColor(red: 56 / 255, green: 85 / 255, blue: 81 / 255, alpha: 1.0))
        
        // Create and configure the bar chart data
        var data: BarChartData?
        if entries != [] {
            data = BarChartData(dataSet: set)
            data!.setValueFont(.systemFont(ofSize: 17, weight: .bold))
            data!.setValueTextColor(.white)
            data!.setValueFormatter(DefaultValueFormatter(formatter: dollarFormatter))
        }
        barChartView.data = data
        barChartView.highlightValues(nil)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if chartView is PieChartView {
            barChartView.leftAxis.axisMaximum = entry.y
            if entry.accessibilityLabel == "pollutionDollars" {
                updateBarChartData(breakdownData: .pollution)
                barChartView.animate(yAxisDuration: 1, easingOption: .easeInOutCubic)
            } else if entry.accessibilityLabel == "energySavingsDollars" {
                updateBarChartData(breakdownData: .energySavings)
                barChartView.animate(yAxisDuration: 1, easingOption: .easeInOutCubic)
            } else {
                updateBarChartData(breakdownData: .none)
            }
        }
    }
}

enum BreakdownData {
    case pollution, energySavings, none
}
