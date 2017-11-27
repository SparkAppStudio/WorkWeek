//
//  NotificationCenterManager.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/17/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

extension NotificationCenter {
    enum CheckInEvent: String {
        case leaveHome
        case arriveWork
        case leaveWork
        case arriveHome
    }

    func post(name: CheckInEvent, object: Any? = nil) {
        let name = Notification.Name(name.rawValue)
        post(name: name, object: object)
    }
}

class NotificationCenterManager {

    static let shared = NotificationCenterManager()

    let notificationCenter = NotificationCenter.default


    func postLeaveHomeNotification() {
        DataStore.shared.saveDataToRealm(for: .leaveHome)
        notificationCenter.post(name: .leaveHome)
    }

    func postArriveWorkNotification() {
        DataStore.shared.saveDataToRealm(for: .arriveWork)
        notificationCenter.post(name: .arriveWork)
    }

    func postLeaveWorkNotification() {
        DataStore.shared.saveDataToRealm(for: .leaveWork)
        notificationCenter.post(name: .leaveWork)
    }

    func postArriveHomeNotification() {
        DataStore.shared.saveDataToRealm(for: .arriveHome)
        notificationCenter.post(name: .arriveHome)
    }
}
