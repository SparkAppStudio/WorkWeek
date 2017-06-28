//
//  NotificationCenterManager.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/17/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

extension NotificationCenter {
    enum CheckInEvents: String {
        case leftHome
        case arriveWork
        case leftWork
        case arriveHome
    }

    func post(name: CheckInEvents, object: Any?) {
        let name = NSNotification.Name(name.rawValue)
        post(name: name, object: object)
    }
}

class NotificationCenterManager {

    static let shared = NotificationCenterManager()

    let notificationCenter = NotificationCenter.default


    func postLeftHomeNotification() {
        saveDataToRealm(forCheckInEvents: .leftHome)
        notificationCenter.post(name: .leftHome, object: nil)
    }

    func postArriveWorkNotification() {
        saveDataToRealm(forCheckInEvents: .arriveWork)
        notificationCenter.post(name: .arriveWork, object: nil)
    }

    func postLeftWorkNotification() {
        saveDataToRealm(forCheckInEvents: .leftWork)
        notificationCenter.post(name: .leftWork, object: nil)
    }

    func postArriveHomeNotification() {
        saveDataToRealm(forCheckInEvents: .arriveHome)
        notificationCenter.post(name: .arriveHome, object: nil)
    }

    func saveDataToRealm(forCheckInEvents: NotificationCenter.CheckInEvents) {

        let key = Date().primaryKeyBasedOnDate()
        print(key)

        let dailyObject = DailyObject()
        dailyObject.dateString = key

        let event = Event(eventName: forCheckInEvents.rawValue, eventTime: Date())

        switch forCheckInEvents {
        case .leftHome:
            dailyObject.timeLeftHome = event
            RealmManager.shared.updateDailyActivities(dailyObject, forCheckInEvents: .leftHome)
        case .arriveWork:
            dailyObject.timeArriveWork = event
            RealmManager.shared.updateDailyActivities(dailyObject, forCheckInEvents: .arriveWork)
        case .leftWork:
            dailyObject.timeLeftWork = event
            RealmManager.shared.updateDailyActivities(dailyObject, forCheckInEvents: .leftWork)
        case .arriveHome:
            dailyObject.timeArriveHome = event
            RealmManager.shared.updateDailyActivities(dailyObject, forCheckInEvents: .arriveHome)
        }
    }
}
