//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class WeeklyGraphCell: UITableViewCell {

    // MARK: - IBs

    @IBOutlet weak var shadownView: UIView!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var timeFrameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var sundayView: ProgressStripeView!
    @IBOutlet weak var mondayView: ProgressStripeView!
    @IBOutlet weak var tuesdayView: ProgressStripeView!
    @IBOutlet weak var wednesdayView: ProgressStripeView!
    @IBOutlet weak var thursdayView: ProgressStripeView!
    @IBOutlet weak var fridayView: ProgressStripeView!
    @IBOutlet weak var saturdayView: ProgressStripeView!

    func configure(_ weekObject: WeeklyObject) {

        setupUI(weekObject.weekDaysWorkingPercentage)
    }

    func setupUI(_ weekDaysWorkingPercentage: WeekDaysWorkingPercent) {
        setCornerRadius()
        setShadow()
        sundayView.percentage = weekDaysWorkingPercentage.sundayPercent
        mondayView.percentage = weekDaysWorkingPercentage.mondayPercent
        tuesdayView.percentage = weekDaysWorkingPercentage.tuesdayPercent
        wednesdayView.percentage = weekDaysWorkingPercentage.wednesdayPercent
        thursdayView.percentage = weekDaysWorkingPercentage.thursdayPercent
        fridayView.percentage = weekDaysWorkingPercentage.fridayPercent
        saturdayView.percentage = weekDaysWorkingPercentage.saturdayPercent
    }

    private func setCornerRadius() {
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.clipsToBounds = true
    }

    private func setShadow() {
        shadownView.layer.masksToBounds = false
        shadownView.layer.shadowOpacity = 0.8
        shadownView.layer.shadowRadius = 3
        shadownView.layer.shadowColor = UIColor.black.cgColor
        shadownView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

