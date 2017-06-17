//
//  NotificationCenterManager.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/17/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import UIKit

enum NotificationNames: String {
    case leftHome
    case arriveWork
    case leftWork
    case arriveHome
}

class NotificationCenterManager {

    static let shared = NotificationCenterManager()

    let notificationCenter = NotificationCenter()

    let leftHomeNotificationName    = NSNotification.Name(rawValue: NotificationNames.leftHome.rawValue)
    let arriveWorkNotificationName  = NSNotification.Name(rawValue: NotificationNames.arriveWork.rawValue)
    let leftWorkNotificationName    = NSNotification.Name(rawValue: NotificationNames.leftWork.rawValue)
    let arriveHomeNotificationName  = NSNotification.Name(rawValue: NotificationNames.arriveHome.rawValue)


    func postLeftHomeNotification() {
        notificationCenter.post(name: leftHomeNotificationName, object: nil)
    }

    func postArriveWorkNotification() {
        notificationCenter.post(name: arriveWorkNotificationName, object: nil)
    }

    func postLeftWorkNotification() {
        notificationCenter.post(name: leftWorkNotificationName, object: nil)
    }

    func postArriveHomeNotification() {
        notificationCenter.post(name: arriveHomeNotificationName, object: nil)
    }
}
