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
    var locationDelegate = LocationDelegate() // swiftlint:disable:this weak_delegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        createLocationManager()

        CrashReporting.configure()

        let parsedOptions = parse(launchOptions)
        Analytics.track(.appLaunch, "", extraData: parsedOptions)

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
        let rect = UIScreen.main.bounds
        locationWindow = UIWindow(frame: rect)
        let gradient = GradientBackgroundView(frame: rect)
        locationWindow?.addSubview(gradient)
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
        }, completion: { _ in
            self.locationWindow = nil
        })
    }

    func configureWindowAndCoordinator() {
        UIApplication.shared.isStatusBarHidden = false

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController()
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()


        appCoordinator = AppCoordinator(with: navigation, locationManager: locationManager)
        appCoordinator.start()

    }

    func createLocationManager() {
        let locationManager = CLLocationManager()
        locationManager.delegate = locationDelegate
        self.locationManager = locationManager
    }

    private func parse(_ options: [UIApplicationLaunchOptionsKey: Any]?) -> [String: Any] {
        guard let options = options else { return [:] }
        var out: [String: Any] = [:]
        for (key, value) in options {
            out[key.rawValue] = value
        }
        return out
    }
}
