//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator {

    let navigationController: UINavigationController
    var childCoordinators = NSMutableArray()

    let locationManager = CLLocationManager()

    init(with navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        let needsSettings = true
        if needsSettings {
            let settingsCoordinator = SettingsCoordinator(with: navigationController, manger: locationManager)
            childCoordinators.add(settingsCoordinator)
            settingsCoordinator.start()
            return
        } else {
            let initial = ActivityPageViewController.instantiate()
            navigationController.setViewControllers([initial], animated: false)
            navigationController.isNavigationBarHidden = true
        }
    }

    func settingsFinished(with coordinator: SettingsCoordinator) {
        childCoordinators.remove(coordinator)
    }
}
