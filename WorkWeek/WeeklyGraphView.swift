//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class WeeklyGraphView: UIView {

    @IBOutlet weak var graphTargetLine: GraphTargetLine!
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var sundayView: ProgressStripeView!
    @IBOutlet weak var mondayView: ProgressStripeView!
    @IBOutlet weak var tuesdayView: ProgressStripeView!
    @IBOutlet weak var wednesdayView: ProgressStripeView!
    @IBOutlet weak var thursdayView: ProgressStripeView!
    @IBOutlet weak var fridayView: ProgressStripeView!
    @IBOutlet weak var saturdayView: ProgressStripeView!

    override func draw(_ rect: CGRect) {
        drawSparkRect(graphStackView.frame, color: UIColor.darkContent(), xInset: -20, yInset: -20, cornerRadius: rect.getRoundedCorner())
    }

    func configure(_ weeklyGraphViewModel: WeeklyGraphViewModel) {
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
}
