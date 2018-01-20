//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

struct CountDownHeaderData: CountdownData {

    var calculator: UserHoursCalculator { return DataStore.shared.getUserCalculator }

    var timeLeftInDay: TimeInterval {
        return calculator.userTimeLeftToday
    }

    var percentOfWorkRemaining: Double {
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

        navigationController.isNavigationBarHidden = false

        let activityVC = ActivityViewController.instantiate()
        activityVC.headerData = CountDownHeaderData()
        activityVC.delegate = self
        let weeks = DataStore.shared.queryAllObjects(ofType: WeeklyObject.self)
        activityVC.tableViewData = ActivityTableViewDSD(with: weeks,
                                                          marginProvider: activityVC,
                                                          action: showWeeklyViewController)
        #if DEBUG
            activityVC.debugDelegate = self
        #endif

        if animated {
            navigationController.viewControllers.insert(activityVC, at: 0)
            navigationController.popWithFadeAnimation()
        } else {
            navigationController.setViewControllers([activityVC], animated: false)
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
        weeklyVC.weekObject = week
        navigationController.pushViewController(weeklyVC, animated: true)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = false
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is ActivityViewController {
            navigationController.isNavigationBarHidden = true

        }
    }

}

extension ActivityCoordinator: UserGettable {
    var vcForPresentation: UIViewController {
        return navigationController
    }
}

extension ActivityCoordinator: ActivityViewDelegate {
    func activityPageDidTapSettings() {
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
