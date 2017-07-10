//  Created by YupinHuPro on 7/1/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Reusable

class WeeklyCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weeklyHourLabel: UILabel!

    func configureCell(for weeklyObject: WeeklyObject) {
        Log.log(weeklyObject.debugDescription)
        let totoalWorkInterval = weeklyObject.dailyObjects.reduce(0.0) { (sum, daily) in
            guard let timeArriveWork = daily.timeArriveWork?.eventTime,
                let timeLeaveWork = daily.timeLeftWork?.eventTime else {
                    return sum
            }
            return sum + timeLeaveWork.timeIntervalSince(timeArriveWork)
        }
        //Use date components formatter
        weeklyHourLabel.text = totoalWorkInterval.convert(preserving: [.hour, .minute, .second])
    }

}
