//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import Foundation

extension Date {
    /// Create a new date its time is 12:00AM on that day
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    /// Create a new date its time is 11:59PM on that day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        guard let endOfDayDate = Calendar.current.date(byAdding: components, to: startOfDay) else {
            assertionFailure("Must create an date for the end of the day")
            return Date()
        }
        return endOfDayDate
    }

    /// Previous days date by simply decrease the day by 1
    var previousDay: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
