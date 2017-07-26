//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import UserNotifications

final class PushNotificationManager {

    func userHasArrivedAtWork() {
        let workHours = RealmManager.shared.getUserHours()

        guard let endDate = Date().byAdding(hours: workHours) else {
            Log.log(.error, "Error building Future Date. Now: \(Date()), adding: \(workHours)")
            return
        }

        let components = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: endDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "End of Work"
        content.subtitle = "Go home"
        content.body = "Some Body to love"
        let req = UNNotificationRequest(identifier: "ArrivedAtWork", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
        // TODO: Add Logging

        // TODO: Can we add a delivery handler, to log when the notifiation is finally shown?
    }

    func userHasDepartedWork() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // TODO: Add Logging Here
    }

}
