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

    let notificationCenter = NotificationCenter()


    func postLeftHomeNotification() {
        notificationCenter.post(name: .leftHome, object: nil)
    }

    func postArriveWorkNotification() {
        notificationCenter.post(name: .arriveWork, object: nil)
    }

    func postLeftWorkNotification() {
        notificationCenter.post(name: .leftWork, object: nil)
    }

    func postArriveHomeNotification() {
        notificationCenter.post(name: .arriveHome, object: nil)
    }
}
