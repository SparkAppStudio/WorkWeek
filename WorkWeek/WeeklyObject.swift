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

    override static func primaryKey() -> String? {
        return #keyPath(WeeklyObject.weekAndTheYear)
    }
}
