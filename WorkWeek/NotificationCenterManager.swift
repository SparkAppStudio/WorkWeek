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
        let name = NSNotification.Name(name.rawValue)
        post(name: name, object: object)
    }
}

class NotificationCenterManager {

    static let shared = NotificationCenterManager()

    let notificationCenter = NotificationCenter.default


    func postLeaveHomeNotification() {
        RealmManager.shared.saveDataToRealm(for: .leaveHome)
        notificationCenter.post(name: .leaveHome)
    }

    func postArriveWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveWork)
        notificationCenter.post(name: .arriveWork)
    }

    func postLeaveWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .leaveWork)
        notificationCenter.post(name: .leaveWork)
    }

    func postArriveHomeNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveHome)
        notificationCenter.post(name: .arriveHome)
    }
}
