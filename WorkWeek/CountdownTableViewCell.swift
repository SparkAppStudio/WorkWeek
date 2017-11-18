//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

//TODO: use the Reusable library
@IBDesignable class CountdownTableViewCell: UITableViewCell, Reusable {

    // MARK: - IBs

    @IBOutlet weak var timeFrameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!

    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var sundayView: ProgressStripeView!
    @IBOutlet weak var mondayView: ProgressStripeView!
    @IBOutlet weak var tuesdayView: ProgressStripeView!
    @IBOutlet weak var wednesdayView: ProgressStripeView!
    @IBOutlet weak var thursdayView: ProgressStripeView!
    @IBOutlet weak var fridayView: ProgressStripeView!
    @IBOutlet weak var saturdayView: ProgressStripeView!
    var margin: CGFloat!
    override func draw(_ rect: CGRect) {
        drawSparkRect(rect, color: UIColor.darkContent(), xInset: margin, yInset: margin/2, cornerRadius: rect.getRoundedCorner())
    }

    func configure(_ weekObject: WeeklyObject) {
        backgroundColor = UIColor.clear
        timeFrameLabel.text = weekObject.weekAndTheYear
        hoursLabel.text = "\(Int(weekObject.totalWorkTime)) hours so far"
        setupUI(weekObject.weekDaysWorkingPercentage)
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

extension CountdownTableViewCell {
    override func prepareForInterfaceBuilder() {
        let dummy = WeeklyObject()
        configure(dummy)
    }
}
