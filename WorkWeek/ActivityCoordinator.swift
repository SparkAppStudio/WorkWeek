//
//  ActivityCoordinator.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 7/10/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation


class ActivityCoordinator: SettingsCoordinatorDelegate, ActivityPageViewDelegate {

    let navigationController: UINavigationController
    let locationManager: CLLocationManager

    var childCoordinators = NSMutableArray()


    init(with navController: UINavigationController,
         manager: CLLocationManager) {

        self.navigationController = navController
        self.locationManager = manager
    }

    func start(animated: Bool) {
        Log.log()

        let activityVC = ActivityPageViewController.instantiate()
        activityVC.activityDelegate = self
        activityVC.locationManager = locationManager
        navigationController.isNavigationBarHidden = true

        if animated {
            navigationController.viewControllers.insert(activityVC, at: 0)
            navigationController.popWithFadeAnimation()

        } else {
            navigationController.setViewControllers([activityVC], animated: false)
        }
    }

    // MARK: ActivityPageViewDelegate

    func pageDidTapSettings() {
        showSettings()
    }

    func showSettings() {

        guard let user = getUserFromRealm() else {
            showErrorAlert()
            return
        }

        let settingsCoordinator = SettingsCoordinator(with: navigationController,
                                                      manger: locationManager,
                                                      user: user,
                                                      delegate: self)
        childCoordinators.add(settingsCoordinator)
        settingsCoordinator.start()
    }


    func getUserFromRealm() -> User? {
        RealmManager.shared.saveInitialUser()
        return RealmManager.shared.queryAllObjects(ofType: User.self).first
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "🤔Error🤔",
                                      message: "Looks like something has gone wrong with our database. Press \"OK\" to restart",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            fatalError()
        }

        alert.addAction(ok)
        navigationController.present(alert, animated: true, completion: nil)
    }

    func settingsFinished(with coordinator: SettingsCoordinator) {
        childCoordinators.remove(coordinator)
    }
}
