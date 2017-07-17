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

    static var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var backDropViewOutlet: UIView!

    func configureCell(_ event: Event) {
        guard let kind = event.kind else {
            Log.log(.error, "event \(event) has missing or invalid `typedKind`")
            return
        }

        switch kind {
        case .leaveHome:
            eventNameLabel.text = "Time Left Home"
        case .arriveWork:
            eventNameLabel.text = "Time Arrived Work"
        case .leaveWork:
            eventNameLabel.text = "Time Left Work"
        case .arriveHome:
            eventNameLabel.text = "Time Arrived Home"
        }

        guard let activityTimeDate = event.value(forKey: #keyPath(Event.eventTime)) as? Date else {
            Log.log(.error, "event \(event) has missing or invalid `eventTime`")
            return
        }
        eventTimeLabel.text = DailyCollectionViewCell.formatter.string(from: activityTimeDate)
    }
}
