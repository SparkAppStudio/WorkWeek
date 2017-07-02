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
        RealmManager.shared.saveDataToRealm(for: .leftHome)
        notificationCenter.post(name: .leftHome, object: nil)
    }

    func postArriveWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveWork)
        notificationCenter.post(name: .arriveWork, object: nil)
    }

    func postLeftWorkNotification() {
        RealmManager.shared.saveDataToRealm(for: .leftWork)
        notificationCenter.post(name: .leftWork, object: nil)
    }

    func postArriveHomeNotification() {
        RealmManager.shared.saveDataToRealm(for: .arriveHome)
        notificationCenter.post(name: .arriveHome, object: nil)
    }
}
