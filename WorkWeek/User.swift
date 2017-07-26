//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

/// Stores the users preferences can be changed in settings or during onboarding
class User: Object {

    static let defaultWorkDayLength = 8.0

    /// The Days on which a user could choose to be notified
    /// Sunday starts at 1 to better align with the Date API's
    /// conformst to `OptionSet` so many can be set at once and stored in realm
    /// as one Int
    struct Weekdays: OptionSet {
        let rawValue: Int

        static let sunday    = Weekdays(rawValue: 1 << 0)
        static let monday    = Weekdays(rawValue: 1 << 1)
        static let tuesday   = Weekdays(rawValue: 1 << 2)
        static let wednesday = Weekdays(rawValue: 1 << 3)
        static let thursday  = Weekdays(rawValue: 1 << 4)
        static let friday    = Weekdays(rawValue: 1 << 5)
        static let saturday  = Weekdays(rawValue: 1 << 6)
    }

    enum NotificationChoice: Int {
        case none
        case daily
        case weekly
    }

    dynamic var hoursInWorkDay: Double = User.defaultWorkDayLength

    // the list of days they want notificaitons for
    // by default Select M-F
    dynamic var weekdaysStorage: Int = {
        var week = Weekdays()
        week.insert(.monday)
        week.insert(.tuesday)
        week.insert(.wednesday)
        week.insert(.thursday)
        week.insert(.friday)
        return week.rawValue  /// 0b0011_1110
    }()

    // Default is No Notifications
    dynamic var notificationChoiceStorage: Int = 0

    var notificationChoice: NotificationChoice {
        get {
            guard let choice = NotificationChoice(rawValue: notificationChoiceStorage) else {
                Log.log(.error, "Could Not build NotificationChoice from \(notificationChoiceStorage)")
                return NotificationChoice.none
            }
            return choice
        }
        set {
            notificationChoiceStorage = newValue.rawValue
        }
    }

    // The storage is an Int, while we'd like our public API to expose the actual options
    // this allows users to do things like
    // `user.weekdays.contains(.monday)`
    var weekdays: Weekdays {
        get {
            return Weekdays(rawValue: weekdaysStorage)
        }
        set {
            weekdaysStorage = newValue.rawValue
        }
    }
}
