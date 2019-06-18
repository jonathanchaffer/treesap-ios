//
//  PieChartDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Charts
import UIKit

class PieChartDisplayViewController: TreeDisplayViewController, ChartViewDelegate {
    // MARK: - Properties

    // Chart views
    @IBOutlet var pieChartView: PieChartView!
    @IBOutlet var barChartView: HorizontalBarChartView!
    
    // Headers
    @IBOutlet weak var annualTreeBenefitsLabel: UILabel!
    @IBOutlet weak var commonNameLabel: UILabel!

    // Number formatter for $x.xx format
    let dollarFormatter = NumberFormatter()

    // Colors for the charts
    let pieChartColors: [UIColor] = [
        UIColor(named: "piechart01")!,
        UIColor(named: "piechart02")!,
        UIColor(named: "piechart03")!,
        UIColor(named: "piechart04")!,
        UIColor(named: "piechart05")!,
        UIColor(named: "piechart06")!,
    ]

    // Legend labels for breakdown data
    let pollutionRemovalLegendLabels = ["CO", "O₃", "NO₂", "SO₂", "PM2.5"]
    let energySavingsLegendLabels = ["Heating", "Cooling"]

    // Variables that keep track of the indices of data with breakdown data
    var pollutionIndex = -1
    var energySavingsIndex = -1

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the common name label
        commonNameLabel.text = self.displayedTree!.commonName

        // Configure the dollar formatter
        dollarFormatter.numberStyle = .currency
        dollarFormatter.maximumFractionDigits = 2
        dollarFormatter.multiplier = 1
        dollarFormatter.currencySymbol = "$"

        // Configure the pie chart
        pieChartView.delegate = self
        pieChartView.drawHoleEnabled = true
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.rotationEnabled = true
        pieChartView.legend.verticalAlignment = .top
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.font = .preferredFont(forTextStyle: .body)
        pieChartView.legend.form = .circle
        pieChartView.legend.formSize = 12
        pieChartView.noDataText = "A pie chart could not be displayed for this tree."
        pieChartView.noDataFont = .preferredFont(forTextStyle: .body)
        pieChartView.noDataTextColor = .black
        pieChartView.noDataTextAlignment = .center

        // Configure the bar chart
        barChartView.delegate = self
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.highlightPerTapEnabled = false
        barChartView.highlightPerDragEnabled = false
        barChartView.legend.font = .preferredFont(forTextStyle: .body)
        barChartView.legend.form = .circle
        barChartView.legend.formSize = 12
        barChartView.noDataText = "Tap certain sections of the pie chart to view a breakdown for that section."
        barChartView.noDataFont = .preferredFont(forTextStyle: .body)
        barChartView.noDataTextColor = .black
        barChartView.noDataTextAlignment = .center

        // Animate in the pie chart
        updatePieChartData()
        pieChartView.animate(yAxisDuration: 1, easingOption: .easeInOutCubic)
    }

    // MARK: - Private functions

    /// Updates the pie chart display.
    private func updatePieChartData() {
        // Initialize data entries
        var entries: [PieChartDataEntry] = []
        let carbonSequestrationDollars = displayedTree!.otherInfo["carbonSequestrationDollars"]
        if carbonSequestrationDollars != nil, carbonSequestrationDollars! > 0 {
            let entry = PieChartDataEntry(value: carbonSequestrationDollars!, label: "CO₂ Sequestration")
            entry.accessibilityLabel = "carbonSequestrationDollars"
            entries.append(entry)
        }
        let avoidedRunoffDollars = displayedTree!.otherInfo["avoidedRunoffDollars"]
        if avoidedRunoffDollars != nil, avoidedRunoffDollars! > 0 {
            let entry = PieChartDataEntry(value: avoidedRunoffDollars!, label: "Rainfall")
            entry.accessibilityLabel = "avoidedRunoffDollars"
            entries.append(entry)
        }
        let carbonAvoidedDollars = displayedTree!.otherInfo["carbonAvoidedDollars"]
        if carbonAvoidedDollars != nil, carbonAvoidedDollars! > 0 {
            let entry = PieChartDataEntry(value: carbonAvoidedDollars!, label: "CO₂ Avoided")
            entry.accessibilityLabel = "carbonAvoidedDollars"
            entries.append(entry)
        }
        let pollutionRemovalDollars = displayedTree!.otherInfo["pollutionRemovalDollars"]
        if pollutionRemovalDollars != nil, pollutionRemovalDollars! > 0 {
            let entry = PieChartDataEntry(value: displayedTree!.otherInfo["pollutionRemovalDollars"]!, label: "Air Quality")
            entry.accessibilityLabel = "pollutionRemovalDollars"
            entries.append(entry)
        }
        let energySavingsDollars = displayedTree!.otherInfo["energySavingsDollars"]
        if energySavingsDollars != nil, energySavingsDollars! > 0 {
            let entry = PieChartDataEntry(value: energySavingsDollars!, label: "Energy")
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
        set.colors = pieChartColors

        // Create and configure the pie chart data
        var data: PieChartData?
        if entries != [] {
            data = PieChartData(dataSet: set)
            data!.setValueFont(.systemFont(ofSize: 17.0, weight: .semibold))
            data!.setValueTextColor(.white)
            data!.setValueFormatter(DefaultValueFormatter(formatter: dollarFormatter))
        } else {
            // If there are no pie chart entries, hide the bar chart and titles
            barChartView.isHidden = true
            annualTreeBenefitsLabel.isHidden = true
            commonNameLabel.isHidden = true
        }
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }

    /**
     Updates the bar chart display given a type of breakdown data.
     - Parameter breakdownData: The type of breakdown data to display.
     */
    private func updateBarChartData(breakdownData: BreakdownData) {
        // Initialize data entries
        var entries: [BarChartDataEntry] = []

        var yValues: [Double] = []
        if breakdownData == .pollutionRemoval {
            let coDollars = displayedTree!.otherInfo["coDollars"]
            if coDollars != nil, coDollars! >= 0 {
                yValues.append(coDollars!)
            }
            let o3Dollars = displayedTree!.otherInfo["o3Dollars"]
            if o3Dollars != nil, o3Dollars! >= 0 {
                yValues.append(o3Dollars!)
            }
            let no2Dollars = displayedTree!.otherInfo["no2Dollars"]
            if no2Dollars != nil, no2Dollars! >= 0 {
                yValues.append(no2Dollars!)
            }
            let so2Dollars = displayedTree!.otherInfo["so2Dollars"]
            if so2Dollars != nil, so2Dollars! >= 0 {
                yValues.append(so2Dollars!)
            }
            let pm25Dollars = displayedTree!.otherInfo["pm25Dollars"]
            if pm25Dollars != nil, pm25Dollars! >= 0 {
                yValues.append(pm25Dollars!)
            }
            entries.append(BarChartDataEntry(x: 0, yValues: yValues))
        } else if breakdownData == .energySavings {
            let heating1Dollars = displayedTree!.otherInfo["heating1Dollars"]
            let heating2Dollars = displayedTree!.otherInfo["heating2Dollars"]
            if heating1Dollars != nil, heating2Dollars != nil, heating1Dollars! + heating2Dollars! >= 0 {
                yValues.append(heating1Dollars! + heating2Dollars!)
            }
            let coolingDollars = displayedTree!.otherInfo["coolingDollars"]
            if coolingDollars != nil, coolingDollars! >= 0 {
                yValues.append(coolingDollars!)
            }
            entries.append(BarChartDataEntry(x: 0, yValues: yValues))
        }

        barChartView.leftAxis.axisMaximum = yValues.sum()

        // Create a data set for the entries
        let set = BarChartDataSet(entries: entries, label: "")

        // Configure the data set
        set.drawIconsEnabled = false
        set.drawValuesEnabled = true

        // Add colors to the data set
        set.colors = pieChartColors

        // Configure the legend
        barChartView.legend.resetCustom()
        if breakdownData == .pollutionRemoval {
            barChartView.legend.setCustom(entries: makeBarChartLegendEntries(for: pollutionRemovalLegendLabels))
        } else if breakdownData == .energySavings {
            barChartView.legend.setCustom(entries: makeBarChartLegendEntries(for: energySavingsLegendLabels))
        }

        // Create and configure the bar chart data
        var data: BarChartData?
        if entries != [] {
            data = BarChartData(dataSet: set)
            data!.setDrawValues(false)
        }
        barChartView.data = data
        barChartView.highlightValues(nil)
    }

    /// Function that gets called when a chart value is selected. Updates bar chart data appropriately.
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight _: Highlight) {
        if chartView is PieChartView {
            if entry.accessibilityLabel == "pollutionRemovalDollars" {
                updateBarChartData(breakdownData: .pollutionRemoval)
                barChartView.animate(yAxisDuration: 1, easingOption: .easeInOutCubic)
            } else if entry.accessibilityLabel == "energySavingsDollars" {
                updateBarChartData(breakdownData: .energySavings)
                barChartView.animate(yAxisDuration: 1, easingOption: .easeInOutCubic)
            } else {
                updateBarChartData(breakdownData: .none)
            }
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if chartView is PieChartView {
            updateBarChartData(breakdownData: .none)
        }
    }

    /**
     Creates an array of legend entries for a given array of legend labels.
     - Parameter labels: The array of legend labels.
     - Returns: An array of legend entries for the given legend labels.
     */
    private func makeBarChartLegendEntries(for labels: [String]) -> [LegendEntry] {
        var entries: [LegendEntry] = []
        for i in 0 ..< labels.count {
            entries.append(LegendEntry(label: labels[i], form: .default, formSize: barChartView.legend.formSize, formLineWidth: barChartView.legend.formLineWidth, formLineDashPhase: barChartView.legend.formLineDashPhase, formLineDashLengths: barChartView.legend.formLineDashLengths, formColor: pieChartColors[i]))
        }
        return entries
    }
}

enum BreakdownData {
    case pollutionRemoval, energySavings, none
}
