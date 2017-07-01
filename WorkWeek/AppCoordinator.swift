//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator: OnboardingCoordinatorDelegate, SettingsCoordinatorDelegate {

    let navigationController: UINavigationController
    var childCoordinators = NSMutableArray()

    let locationManager = CLLocationManager()

    init(with navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        Log.log("\(#file): \(#function)")

        #if DEBUG  // In Debug modes allow going straight to the settings page if, the userdefault key is set
            let showSettingsDEBUG = UserDefaults.standard.bool(for: .overrideShowSettingsFirst)
            if showSettingsDEBUG {
                showSettings()
                return
            }
        #endif

        let userHasSeenOnboarding = UserDefaults.standard.bool(for: .hasSeenOnboarding)
        if userHasSeenOnboarding {
            showActivity()
        } else {
            showOnboarding()
        }
    }

    // MARK: Onboarding
    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(with: navigationController,
                                                          manger: locationManager,
                                                          delegate: self)
        childCoordinators.add(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    func onboardingFinished(with coordinator: OnboardingCoordinator) {
        childCoordinators.remove(coordinator)
        showActivity()
    }

    // MARK: Onboarding Delegate

    // MARK: Activity
    func showActivity() {
        let initial = ActivityPageViewController.instantiate()
        navigationController.setViewControllers([initial], animated: false)
        navigationController.isNavigationBarHidden = true
    }

    // MARK: Settings
    func showSettings() {
        let settingsCoordinator = SettingsCoordinator(with: navigationController,
                                                      manger: locationManager,
                                                      delegate: self)
        childCoordinators.add(settingsCoordinator)
        settingsCoordinator.start()
    }

    func settingsFinished(with coordinator: SettingsCoordinator) {
        childCoordinators.remove(coordinator)
        showActivity()
    }
}

extension UserDefaults {
    enum Key: String {
        case hasSeenOnboarding
        case overrideShowSettingsFirst
    }

    func bool(for key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
}
