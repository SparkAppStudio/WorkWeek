//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator: OnboardingCoordinatorDelegate, SettingsCoordinatorDelegate {

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
        let defaults = UserDefaults.standard
        defaults.set(true, for: .hasSeenOnboarding)
        showActivity(animated: true)
    }

    // MARK: Onboarding Delegate


    // MARK: Activity
    func showActivity(animated: Bool) {
        let activityCR = ActivityCoordinator(with: navigationController, manager: locationManager)
        childCoordinators.add(activityCR)
        activityCR.start(animated: animated)
    }

    // MARK: Settings
    // TODO: eventually will go away but leaving so our build configs still work

    #if DEBUG
    func showSettings() {
        let settingsCoordinator = SettingsCoordinator(with: navigationController,
                                                      manger: locationManager,
                                                      delegate: self)
        childCoordinators.add(settingsCoordinator)
        settingsCoordinator.start()
    }

    func settingsFinished(with coordinator: SettingsCoordinator) {
        childCoordinators.remove(coordinator)
        showActivity(animated: false)
    }
    #endif
}

extension UserDefaults {
    enum Key: String {
        case hasSeenOnboarding
        case overrideShowSettingsFirst
    }

    func bool(for key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }

    func set(_ value: Bool, for key: Key) {
        set(value, forKey: key.rawValue)
    }

    //someday John
//    @available(*, deprecated)
//    open func set(_ value: Bool, forKey defaultName: String) {
//        self.set(value, forKey: defaultName)
//    }
}
