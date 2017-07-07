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

    func post(name: CheckInEvents, object: Any? = nil) {
        let name = NSNotification.Name(name.rawValue)
        post(name: name, object: object)
    }
}

class NotificationCenterManager {

    static let shared = NotificationCenterManager()

    let notificationCenter = NotificationCenter.default


    func postLeftHomeNotification() {
        RealmManager.shared.saveDataToRealm(for: .leftHome)
        notificationCenter.post(name: .leftHome)
    }

    func postArriveWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveWork)
        notificationCenter.post(name: .arriveWork)
    }

    func postLeftWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .leftWork)
        notificationCenter.post(name: .leftWork)
    }

    func postArriveHomeNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveHome)
        notificationCenter.post(name: .arriveHome)
    }
}
