//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyObject: Object {

    @objc dynamic var weekAndTheYear: String?
    let dailyObjects = List<DailyObject>()

    var totalWorkTime: TimeInterval {
        return dailyObjects.reduce(0.0) { (sum, daily) in
            return sum + daily.completedWorkTime
        }
    }

    var weekInterval: (Date, Date)? {
        if let begin = dailyObjects.first?.date, let end = dailyObjects.last?.date {
            return (begin, end)
        } else {
            Log.log(.error,
                    "Error formatting WeekInterval. first: \(dailyObjects.first.debugDescription)"
                        +
                " second: \(dailyObjects.last.debugDescription)")
            return nil
        }
    }

    var weekDaysWorkingHours: WeekDaysWorkingHours {
        var weekDaysWorkingHours = WeekDaysWorkingHours()
        for day in dailyObjects {
            guard let weekDay = day.weekDay else { continue }
            if weekDay == 1 {
                weekDaysWorkingHours.sundayIntervals = day.completedWorkTime
            } else if weekDay == 2 {
                weekDaysWorkingHours.mondayIntervals = day.completedWorkTime
            } else if weekDay == 3 {
                weekDaysWorkingHours.tuesdayIntervals = day.completedWorkTime
            } else if weekDay == 4 {
                weekDaysWorkingHours.wednesdayInterval = day.completedWorkTime
            } else if weekDay == 5 {
                weekDaysWorkingHours.thursdayInterval = day.completedWorkTime
            } else if weekDay == 6 {
                weekDaysWorkingHours.fridayInterval = day.completedWorkTime
            } else if weekDay == 7 {
                weekDaysWorkingHours.saturdayInterval = day.completedWorkTime
            }
        }
        return weekDaysWorkingHours
    }

    var weekDaysWorkingPercentage: WeekDaysWorkingPercent {
        let daysIntervals = weekDaysWorkingHours.daysIntervals
        var weekDaysWorkingPercentage = WeekDaysWorkingPercent()
        guard let biggest = daysIntervals.max() else { return weekDaysWorkingPercentage }
        let daysPercents = daysIntervals.map { $0 / Double(biggest)}
        weekDaysWorkingPercentage.setPercents(values: daysPercents)
        return weekDaysWorkingPercentage
    }

    override static func primaryKey() -> String? {
        return #keyPath(WeeklyObject.weekAndTheYear)
    }
}

struct WeekDaysWorkingHours {
    var sundayIntervals: TimeInterval = 0
    var mondayIntervals: TimeInterval = 0
    var tuesdayIntervals: TimeInterval = 0
    var wednesdayInterval: TimeInterval = 0
    var thursdayInterval: TimeInterval = 0
    var fridayInterval: TimeInterval = 0
    var saturdayInterval: TimeInterval = 0
    var daysIntervals: [TimeInterval] {
        return [sundayIntervals,
                mondayIntervals,
                tuesdayIntervals,
                wednesdayInterval,
                thursdayInterval,
                fridayInterval,
                saturdayInterval
        ]
    }
}

struct WeekDaysWorkingPercent {

    var sundayPercent: Double = 0
    var mondayPercent: Double = 0
    var tuesdayPercent: Double = 0
    var wednesdayPercent: Double = 0
    var thursdayPercent: Double = 0
    var fridayPercent: Double = 0
    var saturdayPercent: Double = 0

    mutating func setPercents(values: [Double]) {
        sundayPercent = values[0]
        mondayPercent = values[1]
        tuesdayPercent = values[2]
        wednesdayPercent = values[3]
        thursdayPercent = values[4]
        fridayPercent = values[5]
        saturdayPercent = values[6]
    }
}

