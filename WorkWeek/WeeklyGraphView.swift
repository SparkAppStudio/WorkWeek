//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

protocol WeeklyGraphViewDelegate: class {
    func didTapDay(_ index: Int)
}

class WeeklyGraphView: UIView {

    @IBOutlet var dayLabels: [UILabel]!

    @IBOutlet weak var graphTargetLine: GraphTargetLine!
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var sundayView: ProgressStripeView!
    @IBOutlet weak var mondayView: ProgressStripeView!
    @IBOutlet weak var tuesdayView: ProgressStripeView!
    @IBOutlet weak var wednesdayView: ProgressStripeView!
    @IBOutlet weak var thursdayView: ProgressStripeView!
    @IBOutlet weak var fridayView: ProgressStripeView!
    @IBOutlet weak var saturdayView: ProgressStripeView!

    weak var delegate: WeeklyGraphViewDelegate!

    func configure(_ weeklyGraphViewModel: WeeklyGraphViewModel) {
        backgroundColor = UIColor.themeBackground()
        for label in dayLabels {
            label.textColor = UIColor.themeText()
        }

        sundayView.percentage = weeklyGraphViewModel.sundayPercent
        mondayView.percentage = weeklyGraphViewModel.mondayPercent
        tuesdayView.percentage = weeklyGraphViewModel.tuesdayPercent
        wednesdayView.percentage = weeklyGraphViewModel.wednesdayPercent
        thursdayView.percentage = weeklyGraphViewModel.thursdayPercent
        fridayView.percentage = weeklyGraphViewModel.fridayPercent
        saturdayView.percentage = weeklyGraphViewModel.saturdayPercent
        graphTargetLine.percentage = weeklyGraphViewModel.graphTargetPercent

        setupTaps()
    }

    private func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

        sundayView.addGestureRecognizer(tap)
        mondayView.addGestureRecognizer(tap)
        tuesdayView.addGestureRecognizer(tap)
        wednesdayView.addGestureRecognizer(tap)
        thursdayView.addGestureRecognizer(tap)
        fridayView.addGestureRecognizer(tap)
        saturdayView.addGestureRecognizer(tap)

    }

    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {

        if sender.view!.contains(sundayView) {
            delegate.didTapDay(0)
        } else if sender.view!.contains(mondayView) {
            delegate.didTapDay(1)
        } else if sender.view!.contains(tuesdayView) {
            delegate.didTapDay(2)
        } else if sender.view!.contains(wednesdayView) {
            delegate.didTapDay(3)
        } else if sender.view!.contains(thursdayView) {
            delegate.didTapDay(4)
        } else if sender.view!.contains(fridayView) {
            delegate.didTapDay(5)
        } else if sender.view!.contains(saturdayView) {
            delegate.didTapDay(6)
        }
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
