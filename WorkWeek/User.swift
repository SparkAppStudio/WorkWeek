//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

/// Stores the users preferences can be changed in settings or during onboarding
class User: Object {

    /// The Days on which a user could choose to be notified
    /// Sunday starts at 1 to better align with the Date API's
    /// conformst to `OptionSet` so many can be set at once and stored in realm
    /// as one Int
    struct Weekdays: OptionSet {
        let rawValue: Int

        static let sunday    = Weekdays(rawValue: 0b0000_0001)
        static let monday    = Weekdays(rawValue: 0b0000_0010)
        static let tuesday   = Weekdays(rawValue: 0b0000_0100)
        static let wednesday = Weekdays(rawValue: 0b0000_1000)
        static let thrusday  = Weekdays(rawValue: 0b0001_0000)
        static let friday    = Weekdays(rawValue: 0b0010_0000)
        static let saturday  = Weekdays(rawValue: 0b0100_0000)
    }

    enum NotificationChoice: Int {
        case none
        case daily
        case weekly
    }

    dynamic var hoursInWorkDay: Double = 8.0

    // the list of days they want notificaitons for
    // by default Select M-F
    dynamic var weekdaysStorage: Int = {
        var week = Weekdays()
        week.insert(.monday)
        week.insert(.tuesday)
        week.insert(.wednesday)
        week.insert(.thrusday)
        week.insert(.friday)
        return week.rawValue
    }()

    // Default is No Notifications
    dynamic var notificationChoice: Int = 0

    // The storage is an Int, while we'd like our public API to expose the actual options
    // this allows users to do things like
    // `user.weekdays.contains(.monday)`
    var weekdays: Weekdays {
        return Weekdays(rawValue: weekdaysStorage)
    }

}
