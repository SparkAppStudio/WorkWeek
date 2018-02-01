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
    var isCurrentWeek: Bool = false

    override func draw(_ rect: CGRect) {
        drawSparkGradientBackground(rect, startColor: UIColor.homeGreen(), endColor: UIColor.workBlue(), xInset: margin, yInset: margin/2, cornerRadius: rect.getRoundedCorner())
        drawSparkRect(rect, color: UIColor.darkContent(), xInset: margin, yInset: margin/2, cornerRadius: rect.getRoundedCorner(), setShadow: true)
    }

    func configure(_ viewModel: WeeklyGraphViewModel) {
        backgroundColor = UIColor.themeBackground()
        timeFrameLabel.text = viewModel.weekRangeText
        if viewModel.weekRangeText == "Current" {
            isCurrentWeek = true
        }
        hoursLabel.text = viewModel.hoursText
        timeFrameLabel.textColor = UIColor.themeText()
        hoursLabel.textColor = UIColor.workBlue()
        for label in dayLabels {
            label.textColor = UIColor.themeText()
        }

        sundayView.workData = viewModel.sunday
        mondayView.workData = viewModel.monday
        tuesdayView.workData = viewModel.tuesday
        wednesdayView.workData = viewModel.wednesday
        thursdayView.workData = viewModel.thursday
        fridayView.workData = viewModel.friday
        saturdayView.workData = viewModel.saturday

        [sundayView, mondayView, tuesdayView,
         wednesdayView, thursdayView, fridayView,
         saturdayView].forEach { view in
            view?.setNeedsDisplay()
        }

        graphTargetLine.targetData = viewModel.graphTarget
        graphTargetLine.setNeedsDisplay()

        guard let today = WeeklyGraphViewModel.thisWeekday, isCurrentWeek == true else { return }
        switch today {
        case 1:
            sundayView.isToday = true
        case 2:
            mondayView.isToday = true
        case 3:
            tuesdayView.isToday = true
        case 4:
            wednesdayView.isToday = true
        case 5:
            thursdayView.isToday = true
        case 6:
            fridayView.isToday = true
        case 7:
            saturdayView.isToday = true
        default:
            break
        }
    }
}

extension ActivityTableViewCell {
    override func prepareForInterfaceBuilder() {
//        let dummy = WeeklyGraphViewModel.init
    }
}
