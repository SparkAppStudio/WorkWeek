//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationWindow: UIWindow?
    var appCoordinator: AppCoordinator!
    var locationManager: CLLocationManager!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        createLocationManager()

        CrashReporting.configure()

        Analytics.track(.appEvent(#function), "App Was launched")

        configureWindowAndCoordinator()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.bool(for: .hasSeenOnboarding) {
            checkLocation()
        }
    }

    func checkLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            dismissLocationWindow()
        return // this is the one we need.
        case .denied, .restricted, .authorizedWhenInUse:
            showLocationWindow()
        case .notDetermined:
            Log.log(.error, "Requesting Always Auth, (they should have been asked in onboarding")
            locationManager.requestAlwaysAuthorization()
        }
    }

    func showLocationWindow() {
        guard locationWindow == nil else { return }
        locationWindow = UIWindow(frame: UIScreen.main.bounds)
        let onboardLocationVC = OnboardLocationViewController.instantiate()
        onboardLocationVC.locationManager = locationManager
        locationWindow?.rootViewController = onboardLocationVC
        locationWindow?.isHidden = false
        locationWindow?.windowLevel = UIWindowLevelStatusBar
    }

    func dismissLocationWindow() {
        guard locationWindow != nil else { return }

        UIView.animate(withDuration: 0.5, animations: {
            self.locationWindow?.alpha = 0
        }) { _ in
            self.locationWindow = nil
        }
    }

    func configureWindowAndCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController()
        window?.rootViewController = navigation

        appCoordinator = AppCoordinator(with: navigation, locationManager: locationManager)
        appCoordinator.start()

        window?.makeKeyAndVisible()
    }

    func createLocationManager() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager = locationManager
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.log(.error, String(describing: error))
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let typedRegion = RegionId(rawValue: region.identifier) else {
            Log.log(.error, "Could not create a typed region from \(region.identifier)")
            return
        }
        switch typedRegion {
        case .home:
            NotificationCenterManager.shared.postArriveHomeNotification()
        case .work:
            NotificationCenterManager.shared.postArriveWorkNotification()
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let typedRegion = RegionId(rawValue:region.identifier) else {
            Log.log(.error, "Could not create a typed region from \(region.identifier)")
            return
        }
        switch typedRegion {
        case .home:
            NotificationCenterManager.shared.postLeftHomeNotification()
        case .work:
            NotificationCenterManager.shared.postLeftWorkNotification()
        }
    }

}
