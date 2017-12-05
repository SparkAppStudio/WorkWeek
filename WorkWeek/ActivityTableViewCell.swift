//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

//TODO: use the Reusable library
@IBDesignable class ActivityTableViewCell: UITableViewCell, Reusable {

    // MARK: - IBs
    @IBOutlet var dayLabels: [UILabel]!

    @IBOutlet weak var timeFrameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!

    @IBOutlet weak var graphTargetLine: GraphTargetLine!
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

    func configure(_ viewModel: WeeklyGraphViewModel) {
        backgroundColor = UIColor.clear
        timeFrameLabel.text = viewModel.timeFrameText
        hoursLabel.text = viewModel.hoursText
        timeFrameLabel.textColor = UIColor.themeText()
        hoursLabel.textColor = UIColor.workBlue()
        for label in dayLabels {
            label.textColor = UIColor.themeText()
        }

        sundayView.percentage = viewModel.sundayPercent
        mondayView.percentage = viewModel.mondayPercent
        tuesdayView.percentage = viewModel.tuesdayPercent
        wednesdayView.percentage = viewModel.wednesdayPercent
        thursdayView.percentage = viewModel.thursdayPercent
        fridayView.percentage = viewModel.fridayPercent
        saturdayView.percentage = viewModel.saturdayPercent

        [sundayView, mondayView, tuesdayView,
         wednesdayView, thursdayView, fridayView,
         saturdayView].forEach { view in
            view?.setNeedsDisplay()
        }
    }
}

extension ActivityTableViewCell {
    override func prepareForInterfaceBuilder() {
//        let dummy = WeeklyGraphViewModel.init
    }
}
