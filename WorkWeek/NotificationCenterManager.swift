//
//  NotificationCenterManager.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/17/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

extension NotificationCenter {
    enum Notes: String {
        case leftHome
        case arriveWork
        case leftWork
        case arriveHome
    }

    func post(name: Notes, object: Any?) {
        let name = NSNotification.Name(name.rawValue)
        post(name: name, object: object)
    }
}

class NotificationCenterManager {

    static let shared = NotificationCenterManager()

    let notificationCenter = NotificationCenter.default


    func postLeftHomeNotification() {
        saveDataToRealm(notes: .leftHome)
        notificationCenter.post(name: .leftHome, object: nil)
    }

    func postArriveWorkNotification() {
        saveDataToRealm(notes: .arriveWork)
        notificationCenter.post(name: .arriveWork, object: nil)
    }

    func postLeftWorkNotification() {
        saveDataToRealm(notes: .leftWork)
        notificationCenter.post(name: .leftWork, object: nil)
    }

    func postArriveHomeNotification() {
        saveDataToRealm(notes: .arriveHome)
        notificationCenter.post(name: .arriveHome, object: nil)
    }

    func saveDataToRealm(notes: NotificationCenter.Notes) {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let todayString = dateFormatter.string(from: today as Date)
        print(todayString)

        let dailyActivity = DailyActivities()
        dailyActivity.dateString = todayString

        switch notes {
        case .leftHome:
            dailyActivity.timeLeftHome = NSDate()
            RealmManager.shared.updateDailyActivities(dailyActivity, forNote: .leftHome)
        case .arriveWork:
            dailyActivity.timeArriveWork = NSDate()
            RealmManager.shared.updateDailyActivities(dailyActivity, forNote: .arriveWork)
        case .leftWork:
            dailyActivity.timeLeftWork = NSDate()
            RealmManager.shared.updateDailyActivities(dailyActivity, forNote: .leftWork)
        case .arriveHome:
            dailyActivity.timeArriveHome = NSDate()
            RealmManager.shared.updateDailyActivities(dailyActivity, forNote: .arriveHome)
        }
    }
}
