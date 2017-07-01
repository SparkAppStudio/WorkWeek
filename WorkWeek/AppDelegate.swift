//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
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

    func configureWindowAndCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController()
        window?.rootViewController = navigation

        appCoordinator = AppCoordinator(with: navigation)
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
            Log.log("Arrived Home")
        case .work:
            Log.log("Arrived Work")
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let typedRegion = RegionId(rawValue:region.identifier) else {
            Log.log(.error, "Could not create a typed region from \(region.identifier)")
            return
        }
        switch typedRegion {
        case .home:
            Log.log("Leaving Home")
        case .work:
            Log.log("Leaving Work")
        }
    }

}
