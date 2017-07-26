//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import UserNotifications

extension UNCalendarNotificationTrigger {

    convenience init?(hoursInFuture workHours: Double) {
        guard let endDate = Date().byAdding(hours: workHours) else {
            Log.log(.error, "Error building Future Date. Now: \(Date()), adding: \(workHours)")
            return nil
        }

        let components = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: endDate)
        self.init(dateMatching: components, repeats: false)
    }
    
}
