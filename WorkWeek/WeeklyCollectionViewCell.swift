//  Created by YupinHuPro on 7/1/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Reusable

class WeeklyCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weeklyHourLabel: UILabel!

    func configureCell(for weeklyObject: WeeklyObject) {
        var totoalWorkInterval = 0.0
        Log.log(weeklyObject.debugDescription)
        for daily in weeklyObject.dailyObjects {
            if let timeArriveWork = daily.timeArriveWork?.value(forKey: "eventTime") as? Date,
                let timeLeaveWork = daily.timeLeftWork?.value(forKey: "eventTime") as? Date {

                let workInterval = timeLeaveWork.timeIntervalSince(timeArriveWork)
                totoalWorkInterval.add(workInterval)
            }
        }
        //Use date components formatter
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        let formattedDuration = formatter.string(from: totoalWorkInterval)
        weeklyHourLabel.text = formattedDuration
    }

}
