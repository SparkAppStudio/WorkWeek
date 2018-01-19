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

        sundayView.workData = weeklyGraphViewModel.sunday
        sundayView.index = 0
        sundayView.delegate = self

        mondayView.workData = weeklyGraphViewModel.monday
        mondayView.index = 1
        mondayView.delegate = self

        tuesdayView.workData = weeklyGraphViewModel.tuesday
        tuesdayView.index = 2
        tuesdayView.delegate = self

        wednesdayView.workData = weeklyGraphViewModel.wednesday
        wednesdayView.index = 3
        wednesdayView.delegate = self

        thursdayView.workData = weeklyGraphViewModel.thursday
        thursdayView.index = 4
        thursdayView.delegate = self

        fridayView.workData = weeklyGraphViewModel.friday
        fridayView.index = 5
        fridayView.delegate = self

        saturdayView.workData = weeklyGraphViewModel.saturday
        saturdayView.index = 6
        saturdayView.delegate = self

//        graphTargetLine.percentage = weeklyGraphViewModel.graphTargetPercent

    }

    func didTapDay(_ index: Int) {
        delegate.didTapDay(index)
    }

}

class WeeklyGraphViewModel {

    let graphTargetPercent: Double
    let sunday: (percent: Double, hours: String)
    let monday: (percent: Double, hours: String)
    let tuesday: (percent: Double, hours: String)
    let wednesday: (percent: Double, hours: String)
    let thursday: (percent: Double, hours: String)
    let friday: (percent: Double, hours: String)
    let saturday: (percent: Double, hours: String)

    let timeFrameText: String
    let hoursText: String

    init(_ weeklyObject: WeeklyObject) {
        let weekPercentage = weeklyObject.weekDaysWorkingPercentage
        let weekHours = weeklyObject.weekDaysWorkingHours

        sunday.percent = weekPercentage.sundayPercent
        sunday.hours = weekHours.sundayIntervals.convertAndFormatCompact(preserving: [.hour])

        monday.percent = weekPercentage.mondayPercent
        monday.hours = weekHours.mondayIntervals.convertAndFormatCompact(preserving: [.hour])

        tuesday.percent = weekPercentage.tuesdayPercent
        tuesday.hours = weekHours.tuesdayIntervals.convertAndFormatCompact(preserving: [.hour])

        wednesday.percent = weekPercentage.wednesdayPercent
        wednesday.hours = weekHours.wednesdayInterval.convertAndFormatCompact(preserving: [.hour])

        thursday.percent = weekPercentage.thursdayPercent
        thursday.hours = weekHours.thursdayInterval.convertAndFormatCompact(preserving: [.hour])

        friday.percent = weekPercentage.fridayPercent
        friday.hours = weekHours.fridayInterval.convertAndFormatCompact(preserving: [.hour])

        saturday.percent = weekPercentage.saturdayPercent
        saturday.hours = weekHours.saturdayInterval.convertAndFormatCompact(preserving: [.hour])

        hoursText = weeklyObject.totalWorkTime.convertAndFormat(preserving: [.hour])

        timeFrameText = weeklyObject.weekAndTheYear ?? ""
        graphTargetPercent = weeklyObject.graphTargetPercentage

    }
}

extension WeeklyGraphViewModel: CustomDebugStringConvertible {
    // swiftlint:disable line_length
    var debugDescription: String {
        return """
        Percents:
        s: \(sunday.percent), m: \(monday.percent), t: \(tuesday.percent), w: \(wednesday.percent), t:\(thursday.percent), f:\(friday.percent), s: \(saturday.percent)

        Target: \(graphTargetPercent),
        Time: \(timeFrameText), Hours: \(hoursText)
        """
    }
    // swiftlint:enable line_length
}
