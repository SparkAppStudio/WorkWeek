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

    func configure(_ weeklyGraphViewModel: WeeklyGraphViewModel) {
        setCornerRadius()
        setShadow()
        sundayView.percentage = weeklyGraphViewModel.sundayPercent
        mondayView.percentage = weeklyGraphViewModel.mondayPercent
        tuesdayView.percentage = weeklyGraphViewModel.tuesdayPercent
        wednesdayView.percentage = weeklyGraphViewModel.wednesdayPercent
        thursdayView.percentage = weeklyGraphViewModel.thursdayPercent
        fridayView.percentage = weeklyGraphViewModel.fridayPercent
        saturdayView.percentage = weeklyGraphViewModel.saturdayPercent
        timeFrameLabel.text = weeklyGraphViewModel.timeFrameText
        hoursLabel.text = weeklyGraphViewModel.hoursText
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

class WeeklyGraphViewModel {

    var sundayPercent: Double = 0
    var mondayPercent: Double = 0
    var tuesdayPercent: Double = 0
    var wednesdayPercent: Double = 0
    var thursdayPercent: Double = 0
    var fridayPercent: Double = 0
    var saturdayPercent: Double = 0
    var timeFrameText: String = ""
    var hoursText: String = ""

    init(_ weeklyObject: WeeklyObject) {
        setupPercentData(weeklyObject.weekDaysWorkingPercentage)
        if let hourString = weeklyObject.totalWorkTime.convert(preserving: [.hour]) {
            if let hourInt = Int(hourString) {
                if hourInt < 2 {
                    hoursText = "\(hourInt) hour"
                } else {
                    hoursText = "\(hourInt) hours"
                }
            }
        }
        if let weekAndTheYear = weeklyObject.weekAndTheYear {
            timeFrameText = weekAndTheYear
        }
    }

    func setupPercentData(_ weekDaysWorkingPercentage: WeekDaysWorkingPercent) {
        sundayPercent = weekDaysWorkingPercentage.sundayPercent
        mondayPercent = weekDaysWorkingPercentage.mondayPercent
        tuesdayPercent = weekDaysWorkingPercentage.tuesdayPercent
        wednesdayPercent = weekDaysWorkingPercentage.wednesdayPercent
        thursdayPercent = weekDaysWorkingPercentage.thursdayPercent
        fridayPercent = weekDaysWorkingPercentage.fridayPercent
        saturdayPercent = weekDaysWorkingPercentage.saturdayPercent
    }

}

