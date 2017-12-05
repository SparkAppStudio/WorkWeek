//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

protocol WeeklyGraphViewDelegate: class {
    func didTapDay(_ index: Int)
}

class WeeklyGraphView: UIView, ProgressStripeViewDelegate {

    @IBOutlet var dayLabels: [UILabel]!

    @IBOutlet weak var graphTargetLine: GraphTargetLine!
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var sundayView: TouchableProgressStripeView!
    @IBOutlet weak var mondayView: TouchableProgressStripeView!
    @IBOutlet weak var tuesdayView: TouchableProgressStripeView!
    @IBOutlet weak var wednesdayView: TouchableProgressStripeView!
    @IBOutlet weak var thursdayView: TouchableProgressStripeView!
    @IBOutlet weak var fridayView: TouchableProgressStripeView!
    @IBOutlet weak var saturdayView: TouchableProgressStripeView!

    weak var delegate: WeeklyGraphViewDelegate!

    func configure(_ weeklyGraphViewModel: WeeklyGraphViewModel) {
        backgroundColor = UIColor.themeBackground()
        for label in dayLabels {
            label.textColor = UIColor.themeText()
        }

        sundayView.percentage = weeklyGraphViewModel.sundayPercent
        sundayView.index = 0
        sundayView.delegate = self

        mondayView.percentage = weeklyGraphViewModel.mondayPercent
        mondayView.index = 1
        mondayView.delegate = self

        tuesdayView.percentage = weeklyGraphViewModel.tuesdayPercent
        tuesdayView.index = 2
        tuesdayView.delegate = self

        wednesdayView.percentage = weeklyGraphViewModel.wednesdayPercent
        wednesdayView.index = 3
        wednesdayView.delegate = self

        thursdayView.percentage = weeklyGraphViewModel.thursdayPercent
        thursdayView.index = 4
        thursdayView.delegate = self

        fridayView.percentage = weeklyGraphViewModel.fridayPercent
        fridayView.index = 5
        fridayView.delegate = self

        saturdayView.percentage = weeklyGraphViewModel.saturdayPercent
        saturdayView.index = 6
        saturdayView.delegate = self

        graphTargetLine.percentage = weeklyGraphViewModel.graphTargetPercent

    }

    func didTapDay(_ index: Int) {
        delegate.didTapDay(index)
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
}

extension WeeklyGraphViewModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        Percents:
        s: \(sundayPercent), m: \(mondayPercent), t: \(tuesdayPercent), w: \(wednesdayPercent), t:\(thursdayPercent), f:\(fridayPercent), s: \(saturdayPercent)

        Target: \(graphTargetPercent),
        Time: \(timeFrameText), Hours: \(hoursText)
        """
    }
}
