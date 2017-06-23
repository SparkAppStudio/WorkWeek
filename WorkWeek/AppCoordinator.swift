//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class AppCoordinator {

    let navigationController: UINavigationController
    var childCoordinators = NSMutableArray()

    init(with navController: UINavigationController) {
        self.navigationController = navController

        if self.navigationController === navController {
            print("same object")
        }
    }

    func start() {
        let needsSettings = true
        if needsSettings {
            let settingsCoordinator = SettingsCoordinator(with: navigationController)
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
