//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

struct CountDown: CountdownData {

    var calculator: UserHoursCalculator { return RealmManager.shared.getUserCalculator }

    var timeLeftInDay: TimeInterval {
        return calculator.getUserTimeLeftToday
    }

    var percentOfWorkRemaining: Int {
        return calculator.percentOfWorkRemaining
    }

    var timeLeftInWeek: TimeInterval {
        return calculator.getUserTimeLeftInWeek()
    }
}

class ActivityCoordinator: SettingsCoordinatorDelegate {

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

        let countdownVC = CountdownViewController.instantiate()
        countdownVC.data = CountDown()
        countdownVC.delegate = self
        navigationController.isNavigationBarHidden = true

        if animated {
            navigationController.viewControllers.insert(countdownVC, at: 0)
            navigationController.popWithFadeAnimation()
        } else {
            navigationController.setViewControllers([countdownVC], animated: false)
        }
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

    func settingsFinished(with coordinator: SettingsCoordinator) {
        childCoordinators.remove(coordinator)
    }
}

extension ActivityCoordinator: UserGettable {
    var vcForPresentation: UIViewController {
        return navigationController
    }
}

extension ActivityCoordinator: CountdownViewDelegate {
    func countdownPageDidTapSettings() {
        showSettings()
    }
}
