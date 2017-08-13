//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyObject: Object {
    dynamic var weekAndTheYear: String?
    let dailyObjects = List<DailyObject>()
    var totalWorkTime: TimeInterval {
        return dailyObjects.reduce(0.0) { (sum, daily) in
            return sum + daily.workTime
        }
    }
    var weekInterval: String {
        if let begin = dailyObjects.first?.date, let end = dailyObjects.last?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            let beginString = dateFormatter.string(from: begin)
            let endString = dateFormatter.string(from: end)
            return beginString + " - " + endString
        } else {
            Log.log(.error,
                    "Error formatting WeekInterval. first: \(dailyObjects.first.debugDescription)"
                        +
                " second: \(dailyObjects.last.debugDescription)")
            return "..."
        }

    }
    override static func primaryKey() -> String? {
        return #keyPath(WeeklyObject.weekAndTheYear)
    }
}
