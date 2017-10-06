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

class ActivityCoordinator: NSObject, SettingsCoordinatorDelegate, UINavigationControllerDelegate {

    let navigationController: UINavigationController
    let locationManager: CLLocationManager

    var childCoordinators = NSMutableArray()


    init(with navController: UINavigationController,
         manager: CLLocationManager) {
        self.navigationController = navController
        self.locationManager = manager
        super.init()
        self.navigationController.delegate = self
    }

    func start(animated: Bool) {
        Log.log()

        navigationController.isNavigationBarHidden = true

        let countdownVC = CountdownViewController.instantiate()
        countdownVC.data = CountDown()
        countdownVC.delegate = self
        countdownVC.selectionDelegate = self

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

    func showWeeklyViewController(for week: String) {
        let weeklyVC = WeeklyOverviewViewController(nibName: nil, bundle: nil)
        navigationController.pushViewController(weeklyVC, animated: true)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is CountdownViewController {
            navigationController.isNavigationBarHidden = true
        } else {
            navigationController.isNavigationBarHidden = false
        }
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

extension ActivityCoordinator: WeeklySelectionDelegate {
    func selectedWeek(_ week: String) {
        showWeeklyViewController(for: week)
    }
}
