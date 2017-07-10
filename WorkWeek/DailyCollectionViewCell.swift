//
//  DailyCollectionViewCell.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/25/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

class DailyCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var backDropViewOutlet: UIView!

    func configureCell(_ event: Event) {
        //TODO: Do you know why this is not a "TypeSafe" property access?
        guard let activityNameString = event.value(forKey: "eventName") as? String else {
            return
        }
        let cases = NotificationCenter.CheckInEvents.self
        switch activityNameString {
        case cases.leaveHome.rawValue:
            eventNameLabel.text = "Time Left Home"
        case cases.arriveWork.rawValue:
            eventNameLabel.text = "Time Arrived Work"
        case cases.leaveWork.rawValue:
            eventNameLabel.text = "Time Left Work"
        case cases.arriveHome.rawValue:
            eventNameLabel.text = "Time Arrived Home"
        default:
            eventNameLabel.text = ""
        }

        guard let activityTimeDate = event.value(forKey: "eventTime") as? Date else {
            return
        }

        eventTimeLabel.text = activityTimeDate.dailyActivityEventDateFormat()


    }
}
