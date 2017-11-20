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
        guard let biggest = daysIntervals.max() else {
            return WeekDaysWorkingPercent.create(with: [0, 0, 0, 0, 0, 0, 0])
        }
        let userWorkDayHours = DataStore.shared.fetchOrCreateUser().workDayTimeInterval
        let options = [biggest, userWorkDayHours]
        let maxInterval = options.max() ?? userWorkDayHours
        let daysPercents = daysIntervals.map { $0 / Double(maxInterval)}
        return WeekDaysWorkingPercent.create(with: daysPercents)
    }

    var graphTargetPercentage: Double {
        let daysIntervals = weekDaysWorkingHours.daysIntervals
        let userWorkInterval = DataStore.shared.fetchOrCreateUser().workDayTimeInterval
        let max = daysIntervals.max() ?? userWorkInterval

        if max <= userWorkInterval {
            return 1.0
        } else {
            return userWorkInterval / max
        }
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

    let sundayPercent: Double
    let mondayPercent: Double
    let tuesdayPercent: Double
    let wednesdayPercent: Double
    let thursdayPercent: Double
    let fridayPercent: Double
    let saturdayPercent: Double

    static func create(with values: [Double]) -> WeekDaysWorkingPercent {
        return WeekDaysWorkingPercent(
            sundayPercent: values[0],
            mondayPercent: values[1],
            tuesdayPercent: values[2],
            wednesdayPercent: values[3],
            thursdayPercent: values[4],
            fridayPercent: values[5],
            saturdayPercent: values[6]
        )
    }
}

