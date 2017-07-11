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

    func configureCell(_ event: Event) {
        // TODO: Do you know why this is not a "TypeSafe" property access?
        // TODO: Update this code to not be so "Stringy"
        // i.e. We're getting a string from the event, then switching over it, to match 
        // an enums raw value then returning a string.
        // Perhaps Event should know what type of Notification Created it...
        // then we could switch over that EventType, to find the correct display String. 
        guard let activityNameString = event.value(forKey: #keyPath(Event.eventName)) as? String else {
            return
        }
        let cases = NotificationCenter.CheckInEvent.self
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

        guard let activityTimeDate = event.value(forKey: #keyPath(Event.eventTime)) as? Date else {
            return
        }

        eventTimeLabel.text = activityTimeDate.dailyActivityEventDateFormat()
    }
}
