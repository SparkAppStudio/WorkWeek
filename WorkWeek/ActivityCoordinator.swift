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

        let activityVC = ActivityPageViewController.instantiate()
        activityVC.orderedViewControllers = configOrderedViewControllers()
        activityVC.locationManager = locationManager
        navigationController.isNavigationBarHidden = true

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

    func configOrderedViewControllers() -> [UIViewController] {
        let userCaluclator = RealmManager.shared.getUserCalculator

        if !userCaluclator.hasDataForThisWeek {
            // User has no data for This week...

            var missingDataVCs: [UIViewController] = []
            let coach = NoDataCoachViewController(nibName: nil, bundle: nil)
            missingDataVCs.append(coach)
            if userCaluclator.hasDataForPreviousWeek {
                let weeklyVC = WeeklyCollectionViewController.instantiate()
                weeklyVC.title = "Weekly Report"
                let navWeeklyVC = UINavigationController(rootViewController: weeklyVC)
                missingDataVCs.append(navWeeklyVC)
            }
            return missingDataVCs
        }

        // The usuall case of use has real data for this week and last week.

        let countdownVC = CountdownViewController.instantiate()
        countdownVC.data = CountDown()
        countdownVC.title = "Count Down"
        let navCountdownVC = UINavigationController(rootViewController: countdownVC)
        countdownVC.delegate = self

        let dailyVC = DailyCollectionViewController.instantiate()
        dailyVC.title = "Daily Activity"
        let navDailyVC = UINavigationController(rootViewController: dailyVC)
        let weeklyVC = WeeklyCollectionViewController.instantiate()
        weeklyVC.title = "Weekly Report"
        let navWeeklyVC = UINavigationController(rootViewController: weeklyVC)

        return [navCountdownVC, navDailyVC, navWeeklyVC]
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

class BlueViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
