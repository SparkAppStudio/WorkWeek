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

        DataStore.shared.fetchOrCreateUser()
    }

    func showOnboarding() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

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
        UIApplication.shared.statusBarStyle = AppCoordinator.getThemeStatusBarStyle()

        let activityCR = ActivityCoordinator(with: navigationController, manager: locationManager)
        childCoordinators.add(activityCR)
        activityCR.start(animated: animated)
    }
}

#if DEBUG

    extension AppCoordinator: SettingsCoordinatorDelegate, UserGettable {

        var vcForPresentation: UIViewController {
            return navigationController
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
            showActivity(animated: false)
        }

    }
#endif
