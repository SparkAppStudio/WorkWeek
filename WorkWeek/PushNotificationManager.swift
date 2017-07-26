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
        content.sound = UNNotificationSound.default()
        let req = UNNotificationRequest(identifier: "ArrivedAtWork", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
        Log.log("Arrived Work. Notification scheduled for: \(endDate)")
    }

    func userHasDepartedWork() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { (req) in
            if req.count > 0 {
                Log.log("User Departed work. Canceling \(req.count) un-delivered notifications")
            }
        })
        center.removeAllPendingNotificationRequests()
    }

}
