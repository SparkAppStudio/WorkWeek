//
//  ActivityCoordinator.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 7/10/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation


protocol ActivityCoordinatorDelegate: class {
    func activityRequestedSettings(with coordinator: ActivityCoordinator)
}

class ActivityCoordinator: SettingsCoordinatorDelegate, ActivityPageViewDelegate {

    let navigationController: UINavigationController
    let locationManager: CLLocationManager
    weak var delegate: ActivityCoordinatorDelegate?

    var childCoordinators = NSMutableArray()


    init(with navController: UINavigationController,
         manager: CLLocationManager,
         delegate: ActivityCoordinatorDelegate) {

        self.navigationController = navController
        self.locationManager = manager
        self.delegate = delegate
    }

    func start(animated: Bool) {
        Log.log()

        let initial = ActivityPageViewController.instantiate()
        initial.activityDelegate = self
        initial.locationManager = locationManager
        navigationController.isNavigationBarHidden = true

        if animated {
            navigationController.viewControllers.insert(initial, at: 0)
            navigationController.popWithFadeAnimation()

        } else {
            navigationController.setViewControllers([initial], animated: false)
        }
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

    func showActivity() {
        let initial = ActivityPageViewController.instantiate()
        navigationController.setViewControllers([initial], animated: false)
        navigationController.isNavigationBarHidden = true
    }

    func pageDidTapSettings() {
        showSettings()
    }
}
