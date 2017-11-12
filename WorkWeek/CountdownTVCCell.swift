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
        for (index, day) in weeklyObject.dailyObjects.enumerated() {
            // given a data, i need to figure out days
            let cal = Calendar.current
            let dateComp = cal.dateComponents(in: .current, from: day.date!)
            print(dateComp.weekday)


        }
        mondayView.percentage = 0.9
    }
}
