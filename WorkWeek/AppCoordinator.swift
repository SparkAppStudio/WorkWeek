//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator: OnboardingCoordinatorDelegate {

    let locationManager: CLLocationManager
    let navigationController: UINavigationController
    var childCoordinators = NSMutableArray()

    init(with navController: UINavigationController, locationManager: CLLocationManager) {
        self.navigationController = navController
        self.locationManager = locationManager
    }

    func start() {
        Log.log()

        #if DEBUG  // In Debug modes allow going straight to the settings page if, the userdefault key is set
            let showSettingsDEBUG = UserDefaults.standard.bool(for: .overrideShowSettingsFirst)
            if showSettingsDEBUG {
                showSettings()
                return
            }
        #endif

        let userHasSeenOnboarding = UserDefaults.standard.bool(for: .hasSeenOnboarding)
        if userHasSeenOnboarding {
            showActivity(animated: false)
        } else {
            showOnboarding()
        }

        RealmManager.shared.saveInitialUser()
    }

    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(with: navigationController,
                                                          manger: locationManager,
                                                          delegate: self)
        childCoordinators.add(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    func onboardingFinished(with coordinator: OnboardingCoordinator) {
        childCoordinators.remove(coordinator)
        let defaults = UserDefaults.standard
        defaults.set(true, for: .hasSeenOnboarding)
        showActivity(animated: true)
    }

    func showActivity(animated: Bool) {
        let activityCR = ActivityCoordinator(with: navigationController, manager: locationManager)
        childCoordinators.add(activityCR)
        activityCR.start(animated: animated)
    }
}

#if DEBUG

    extension AppCoordinator: SettingsCoordinatorDelegate {

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
            showActivity(animated: false)
        }

        func getUserFromRealm() -> User? {
            RealmManager.shared.saveInitialUser()
            return RealmManager.shared.queryAllObjects(ofType: User.self).first
        }

        func showErrorAlert() {
            let alert = UIAlertController(title: "🤔Error🤔",
                                          message: "Looks like something has gone wrong with our database. Press \"OK\" to restart",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                fatalError()
            }

            alert.addAction(ok)
            navigationController.present(alert, animated: true, completion: nil)
        }


    }
#endif
