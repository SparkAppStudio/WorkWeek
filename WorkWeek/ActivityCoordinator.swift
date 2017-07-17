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
        let settingsCoordinator = SettingsCoordinator(with: navigationController,
                                                      manger: locationManager,
                                                      delegate: self)
        childCoordinators.add(settingsCoordinator)
        settingsCoordinator.start()
    }

    func settingsFinished(with coordinator: SettingsCoordinator) {
        childCoordinators.remove(coordinator)
    }
}