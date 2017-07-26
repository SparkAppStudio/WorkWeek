//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

extension Date {

    func byAdding(hours: Double) -> Date? {

        let minutesInHour = 60.0
        let workHoursInMinutes = Int(hours * minutesInHour)

        return Calendar.current.date(byAdding: .minute, value: workHoursInMinutes, to: self)
    }
}
