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

    func configure(_ weeklyObject: WeeklyObject) {
        sundayView.percentage = weeklyObject.weekDaysWorkingPercentage.sundayPercent
        mondayView.percentage = weeklyObject.weekDaysWorkingPercentage.mondayPercent
        tuesdayView.percentage = weeklyObject.weekDaysWorkingPercentage.tuesdayPercent
        wednesdayView.percentage = weeklyObject.weekDaysWorkingPercentage.wednesdayPercent
        thursdayView.percentage = weeklyObject.weekDaysWorkingPercentage.thursdayPercent
        fridayView.percentage = weeklyObject.weekDaysWorkingPercentage.fridayPercent
        saturdayView.percentage = weeklyObject.weekDaysWorkingPercentage.saturdayPercent
    }
}
