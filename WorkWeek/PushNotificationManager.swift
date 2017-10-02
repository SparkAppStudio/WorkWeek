//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import UserNotifications

final class PushNotificationManager: NSObject {

    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }

    lazy var calculator = RealmManager.shared.getUserCalculator

    func userHasArrivedAtWork() {
        let workTimeLeft = calculator.getUserTimeLeftToday
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: workTimeLeft, repeats: false)
        let content = buildMessage()
        let req = UNNotificationRequest(identifier: "ArrivedAtWork", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }

    func buildMessage() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "You Did It"
        content.body = "🏄 You reached your goal. Enjoy. 🙌"
        content.sound = UNNotificationSound.default()
        return content
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

extension PushNotificationManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }

}
