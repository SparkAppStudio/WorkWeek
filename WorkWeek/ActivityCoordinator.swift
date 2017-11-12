//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

struct CountDownHeaderData: CountdownData {

    var calculator: UserHoursCalculator { return RealmManager.shared.getUserCalculator }

    var timeLeftInDay: TimeInterval {
        return calculator.userTimeLeftToday
    }

    var percentOfWorkRemaining: Int {
        return calculator.percentOfWorkRemaining
    }

    var timeLeftInWeek: TimeInterval {
        return calculator.userTimeLeftInWeek
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
        countdownVC.headerData = CountDownHeaderData()
        countdownVC.delegate = self
        let weeks = RealmManager.shared.queryAllObjects(ofType: WeeklyObject.self)
        countdownVC.tableViewData = CountDownTableViewDSD(with: weeks,
                                                          action: showWeeklyViewController)
        #if DEBUG
            countdownVC.debugDelegate = self
        #endif

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

    func showWeeklyViewController(for week: WeeklyObject) {
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


#if DEBUG
extension ActivityCoordinator: DebugMenuShowing {
    func showDebugMenu() {
        navigationController.presentDevSettingsAlertController()
    }
}
#endif
