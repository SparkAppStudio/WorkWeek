//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class AppCoordinator {

    let navigationController: UINavigationController
    var childCoordinators = [Any]()

    init(with navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        let needsSettings = true
        if needsSettings {
            let settingsCoordinator = SettingsCoordinator(with: navigationController)
            childCoordinators.append(settingsCoordinator)
            settingsCoordinator.start()
            return
        } else {
            let initial = ActivityPageViewController.instantiate()
            navigationController.setViewControllers([initial], animated: false)
            navigationController.isNavigationBarHidden = true
        }
    }



}
