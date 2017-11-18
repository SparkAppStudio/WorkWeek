//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class WeeklyGraphView: UIView {

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

    func setupUI(_ weekDaysWorkingPercentage: WeekDaysWorkingPercent) {
        sundayView.percentage = weekDaysWorkingPercentage.sundayPercent
        mondayView.percentage = weekDaysWorkingPercentage.mondayPercent
        tuesdayView.percentage = weekDaysWorkingPercentage.tuesdayPercent
        wednesdayView.percentage = weekDaysWorkingPercentage.wednesdayPercent
        thursdayView.percentage = weekDaysWorkingPercentage.thursdayPercent
        fridayView.percentage = weekDaysWorkingPercentage.fridayPercent
        saturdayView.percentage = weekDaysWorkingPercentage.saturdayPercent
    }


}
