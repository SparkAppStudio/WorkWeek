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

        sundayView.percentage = viewModel.sundayPercent
        mondayView.percentage = viewModel.mondayPercent
        tuesdayView.percentage = viewModel.tuesdayPercent
        wednesdayView.percentage = viewModel.wednesdayPercent
        thursdayView.percentage = viewModel.thursdayPercent
        fridayView.percentage = viewModel.fridayPercent
        saturdayView.percentage = viewModel.saturdayPercent
    }
}

extension CountdownTableViewCell {
    override func prepareForInterfaceBuilder() {
//        let dummy = WeeklyGraphViewModel.init
    }
}
