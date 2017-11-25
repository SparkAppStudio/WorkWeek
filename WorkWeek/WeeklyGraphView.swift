//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class WeeklyGraphView: UIView {

    @IBOutlet var dayLabels: [UILabel]!
    @IBOutlet weak var graphTargetLine: GraphTargetLine!
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var sundayView: ProgressStripeView!
    @IBOutlet weak var mondayView: ProgressStripeView!
    @IBOutlet weak var tuesdayView: ProgressStripeView!
    @IBOutlet weak var wednesdayView: ProgressStripeView!
    @IBOutlet weak var thursdayView: ProgressStripeView!
    @IBOutlet weak var fridayView: ProgressStripeView!
    @IBOutlet weak var saturdayView: ProgressStripeView!

    func configure(_ weeklyGraphViewModel: WeeklyGraphViewModel) {
        backgroundColor = UIColor.themeBackground()
        for label in dayLabels {
            label.textColor = UIColor.themeText()
        }

        sundayView.percentage = weeklyGraphViewModel.sundayPercent
        mondayView.percentage = weeklyGraphViewModel.mondayPercent
        tuesdayView.percentage = weeklyGraphViewModel.tuesdayPercent
        wednesdayView.percentage = weeklyGraphViewModel.wednesdayPercent
        thursdayView.percentage = weeklyGraphViewModel.thursdayPercent
        fridayView.percentage = weeklyGraphViewModel.fridayPercent
        saturdayView.percentage = weeklyGraphViewModel.saturdayPercent
        graphTargetLine.percentage = weeklyGraphViewModel.graphTargetPercent
    }
}

class WeeklyGraphViewModel {

    let graphTargetPercent: Double
    let sundayPercent: Double
    let mondayPercent: Double
    let tuesdayPercent: Double
    let wednesdayPercent: Double
    let thursdayPercent: Double
    let fridayPercent: Double
    let saturdayPercent: Double
    let timeFrameText: String
    let hoursText: String

    init(_ weeklyObject: WeeklyObject) {
        let weekDaysWorkingPercentage = weeklyObject.weekDaysWorkingPercentage
        sundayPercent = weekDaysWorkingPercentage.sundayPercent
        mondayPercent = weekDaysWorkingPercentage.mondayPercent
        tuesdayPercent = weekDaysWorkingPercentage.tuesdayPercent
        wednesdayPercent = weekDaysWorkingPercentage.wednesdayPercent
        thursdayPercent = weekDaysWorkingPercentage.thursdayPercent
        fridayPercent = weekDaysWorkingPercentage.fridayPercent
        saturdayPercent = weekDaysWorkingPercentage.saturdayPercent
        let hourString = weeklyObject.totalWorkTime.convert(preserving: [.hour]) ?? ""
        if let hourInt = Int(hourString) {
            hoursText = "\(hourInt) \(hourInt < 2 ? "hour": "hours")"
        } else {
            hoursText = ""
        }
        timeFrameText = weeklyObject.weekAndTheYear ?? ""
        graphTargetPercent = weeklyObject.graphTargetPercentage
    }

    init(_ percentArray: [Double], hoursWorked: Int) {
        sundayPercent = percentArray[0]
        mondayPercent = percentArray[1]
        tuesdayPercent = percentArray[2]
        wednesdayPercent = percentArray[3]
        thursdayPercent = percentArray[4]
        fridayPercent = percentArray[5]
        saturdayPercent = percentArray[6]
        hoursText = "\(hoursWorked) \(hoursWorked < 2 ? "hour": "hours")"
        timeFrameText = "Time Frame"
        graphTargetPercent = 1
    }
}
