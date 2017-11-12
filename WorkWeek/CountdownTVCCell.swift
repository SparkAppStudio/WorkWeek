//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class CountdownTVCCell: UITableViewCell {

    // MARK: - IBs

    @IBOutlet weak var timeFrameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var sundayView: ProgressStripeView!
    @IBOutlet weak var mondayView: ProgressStripeView!
    @IBOutlet weak var tuesdayView: ProgressStripeView!
    @IBOutlet weak var wednesdayView: ProgressStripeView!
    @IBOutlet weak var thursdayView: ProgressStripeView!
    @IBOutlet weak var fridayView: ProgressStripeView!
    @IBOutlet weak var saturdayView: ProgressStripeView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ weekDaysWorkingPercentage:WeekDaysWorkingPercent) {
        sundayView.percentage = weekDaysWorkingPercentage.sundayPercent
        mondayView.percentage = weekDaysWorkingPercentage.mondayPercent
        tuesdayView.percentage = weekDaysWorkingPercentage.tuesdayPercent
        wednesdayView.percentage = weekDaysWorkingPercentage.wednesdayPercent
        thursdayView.percentage = weekDaysWorkingPercentage.thursdayPercent
        fridayView.percentage = weekDaysWorkingPercentage.fridayPercent
        saturdayView.percentage = weekDaysWorkingPercentage.saturdayPercent
    }
}
