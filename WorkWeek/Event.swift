//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var eventTime: Date = Date()
    @objc dynamic private var kindStorage: String? = ""

    var kind: NotificationCenter.CheckInEvent? {
        guard let kindStorage = kindStorage else {
            Log.log(.error, "event \(self) has missing or invalid `kind`")
            return nil
        }
        return NotificationCenter.CheckInEvent(rawValue: kindStorage)
    }

    convenience init(kind: NotificationCenter.CheckInEvent, time: Date) {
        self.init()
        self.kindStorage = kind.rawValue
        self.eventTime = time
    }

    var midnightToLeaveInterval: TimeInterval {
        let startOfDay = eventTime.startOfDay
        return eventTime.timeIntervalSince(startOfDay)
    }

    var arriveWorkToMidnightInterval: TimeInterval {
        let endOfDay = eventTime.endOfDay
        return endOfDay.timeIntervalSince(eventTime)
    }

}
