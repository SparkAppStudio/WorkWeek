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
        case leaveHome
        case arriveWork
        case leaveWork
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


    func postLeaveHomeNotification() {
        RealmManager.shared.saveDataToRealm(for: .leaveHome)
        notificationCenter.post(name: .leaveHome, object: nil)
    }

    func postArriveWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveWork)
        notificationCenter.post(name: .arriveWork, object: nil)
    }

    func postLeaveWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .leaveWork)
        notificationCenter.post(name: .leaveWork, object: nil)
    }

    func postArriveHomeNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveHome)
        notificationCenter.post(name: .arriveHome, object: nil)
    }
}
