//
//  DailyCollectionViewCell.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/25/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit


class DailyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var activityTime: UILabel!

    func configureCell(_ dailyActivity: Event) {

        guard let activityNameString = dailyActivity.value(forKey: "eventName") as? String else {
            return
        }
        let cases = NotificationCenter.CheckInEvents.self
        switch activityNameString {
        case cases.leftHome.rawValue:
            activityName.text = "Time Left Home"
        case cases.arriveWork.rawValue:
            activityName.text = "Time Arrived Work"
        case cases.leftWork.rawValue:
            activityName.text = "Time Left Work"
        case cases.arriveHome.rawValue:
            activityName.text = "Time Arrived Home"
        default:
            activityName.text = ""
        }

        guard let activityTimeDate = dailyActivity.value(forKey: "eventTime") as? Date else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        activityTime.text = dateFormatter.string(from: activityTimeDate as Date)
    }
}
