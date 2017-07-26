//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import UserNotifications

final class PushNotificationManager {

    func userHasArrivedAtWork() {
        // TODO: The logic here is not quite correct, It will only fire properly
        // if the user arrives at work and then does not leave for 8 hours
        // if they exit the office for lunch when the re-arrive at work the the
        // new Notification needs to be based on the time left in the day / week
        let workHours = RealmManager.shared.getUserHours()

        guard let trigger = UNCalendarNotificationTrigger(hoursInFuture: workHours) else {
            Log.log(.error, "Nil Trigger for Future Date. Now: \(Date()), adding: \(workHours)")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "End of Work"
        content.subtitle = "Go home"
        content.body = "Some Body to love"
        content.sound = UNNotificationSound.default()
        let req = UNNotificationRequest(identifier: "ArrivedAtWork", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
        Log.log("Arrived Work. Notification scheduled for: \(trigger.nextTriggerDate())")
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
