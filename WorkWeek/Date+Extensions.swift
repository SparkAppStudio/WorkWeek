//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

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
}
