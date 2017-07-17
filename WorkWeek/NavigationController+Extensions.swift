//
//  NavigationController+Extensions.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 7/1/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popWithFadeAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        self.popViewController(animated: false)
    }

    // MARK: Dev Settings

    #if DEBUG

    func presentDevSettingsAlertController() {
        let alert = UIAlertController(title: "DEV SETTINGS", message: nil, preferredStyle: .actionSheet)

        let arriveHomeAction = UIAlertAction(title: "Arrive Home", style: .default) { (_) in
            NotificationCenterManager.shared.postArriveHomeNotification()
        }

        let leaveHomeAction = UIAlertAction(title: "Leave Home", style: .default) { (_) in
            NotificationCenterManager.shared.postLeaveHomeNotification()
        }

        let arriveWorkAction = UIAlertAction(title: "Arrive Work", style: .default) { (_) in
            NotificationCenterManager.shared.postArriveWorkNotification()
        }

        let leaveWorkAction = UIAlertAction(title: "Leave Work", style: .default) { (_) in
            NotificationCenterManager.shared.postLeaveWorkNotification()
        }

        let showAllRealmAction = UIAlertAction(title: "Show Realm Data", style: .default) { (_) in
            RealmManager.shared.queryAllDailyObjects()
        }

        let removeAllRealmAction = UIAlertAction(title: "Remove Realm Data", style: .default) { (_) in
            RealmManager.shared.removeAllObjects()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(arriveHomeAction)
        alert.addAction(leaveHomeAction)
        alert.addAction(arriveWorkAction)
        alert.addAction(leaveWorkAction)
        alert.addAction(showAllRealmAction)
        alert.addAction(removeAllRealmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    #endif
}
