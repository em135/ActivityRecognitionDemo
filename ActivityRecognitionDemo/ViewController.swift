//
//  ViewController.swift
//  ActivityRecognitionDemo
//
//  Created by Emil Nielsen on 14/11/2019.
//  Copyright © 2019 Emil Nielsen. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!

    private var automotiveDataEntry = PieChartDataEntry()
    private var cyclingDataEntry = PieChartDataEntry()
    private var runningDataEntry = PieChartDataEntry()
    private var walkingDataEntry = PieChartDataEntry()
    private var stationaryDataEntry = PieChartDataEntry()
    private var unknownDataEntry = PieChartDataEntry()
    private var dataEntries = [PieChartDataEntry]()

    private var activityManager: CMMotionActivityManager!
    private var pieData: PieChartData!

    override func viewDidLoad() {
        super.viewDidLoad()

        activityManager = CMMotionActivityManager()

        setUpDataEntries()
        setUpPieChartProperties()
        startRecognizing()
    }

    private func setUpDataEntries() {
        automotiveDataEntry.label = "Automotive"
        cyclingDataEntry.label = "Cycling"
        runningDataEntry.label = "Running"
        walkingDataEntry.label = "Walking"
        stationaryDataEntry.label = "Stationary"
        walkingDataEntry.label = "Walking"
        unknownDataEntry.label = "Unknown"

        dataEntries = [automotiveDataEntry, cyclingDataEntry, walkingDataEntry, runningDataEntry, stationaryDataEntry, unknownDataEntry]
    }

    private func setUpPieChartProperties() {
        let pieDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieData = PieChartData(dataSet: pieDataSet)

        let colors = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)]
        pieDataSet.colors = colors

        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        pieDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        pieChart.drawEntryLabelsEnabled = false
    }

    private func updateChart() {
        pieChart.data = pieData
    }

    private func startRecognizing() {
        activityManager?.startActivityUpdates(to: OperationQueue.main, withHandler: { activity in
            if let activity = activity {
                if activity.automotive {
                    self.automotiveDataEntry.value += 1
                } else if activity.cycling {
                    self.cyclingDataEntry.value += 1
                } else if activity.running {
                    self.runningDataEntry.value += 1
                } else if activity.walking {
                    self.walkingDataEntry.value += 1
                } else if activity.stationary {
                    self.stationaryDataEntry.value += 1
                } else if activity.unknown {
                    self.unknownDataEntry.value += 1
                }
                self.updateChart()
            }
        })
    }

}

