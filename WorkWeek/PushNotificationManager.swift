//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import UserNotifications

protocol SparkNotificationCenter {
    var delegate: UNUserNotificationCenterDelegate? { get set }
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Swift.Void)?)
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Swift.Void)
    func removeAllPendingNotificationRequests()
}

extension UNUserNotificationCenter: SparkNotificationCenter { }

final class PushNotificationManager: NSObject {

    let center: SparkNotificationCenter
    let calculator: UserHoursCalculator

    init(center: UNUserNotificationCenter = UNUserNotificationCenter.current(),
         calculator: UserHoursCalculator = DataStore.shared.getUserCalculator
        ) {
        self.center = center
        self.calculator = calculator
        super.init()
        center.delegate = self
    }

    func userHasArrivedAtWork() {
        switch calculator.notificationChoice {
        case .none:
            return
        case .daily:
            prepareDailyNotification()
        case .weekly:
            prepareWeeklyNotification()
        }
    }

    func prepareDailyNotification() {
        let workTimeLeft = calculator.userTimeLeftToday
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: workTimeLeft, repeats: false)
        let content = buildMessage()
        let req = UNNotificationRequest(identifier: "ArrivedAtWork", content: content, trigger: trigger)

        center.add(req, withCompletionHandler: nil)
    }

    func prepareWeeklyNotification() {
        let workTimeLeft = calculator.userTimeLeftInWeek
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: workTimeLeft, repeats: false)
        let content = buildMessage()
        let req = UNNotificationRequest(identifier: "ArrivedAtWork", content: content, trigger: trigger)

        center.add(req, withCompletionHandler: nil)
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
