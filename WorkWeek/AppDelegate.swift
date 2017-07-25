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

    var pushManager: PushNotificationManager!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        createLocationManager()
        createPushNotificationManager()

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
        window?.makeKeyAndVisible()

        appCoordinator = AppCoordinator(with: navigation, locationManager: locationManager)
        appCoordinator.start()

    }

    func createLocationManager() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager = locationManager
    }

    func createPushNotificationManager() {
        pushManager = PushNotificationManager()
    }

}

extension AppDelegate: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // When user becomes authorized, update their location, so the map will 
        // be up to date when they get to it
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            break
        }
    }

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
            pushManager.handleArrivedAtWork()
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let typedRegion = RegionId(rawValue:region.identifier) else {
            Log.log(.error, "Could not create a typed region from \(region.identifier)")
            return
        }
        switch typedRegion {
        case .home:
            NotificationCenterManager.shared.postLeaveHomeNotification()
        case .work:
            NotificationCenterManager.shared.postLeaveWorkNotification()
            pushManager.handleDepartedWork()
        }
    }

}


import UserNotifications

final class PushNotificationManager {

    func handleArrivedAtWork() {
        let workHours = RealmManager.shared.getUserHours()

        let content = UNMutableNotificationContent()
        content.title = "End of Work"
        content.subtitle = "Go home"
        content.body = "Some Body to love"

        // TODO: Clean up this function
        func endDateAddingHours(hours: Double) -> Date? {
            let now = Date()

            let minutesInHour = 60.0
            let workHoursInMinutes = Int(workHours * minutesInHour)

            return Calendar.current.date(byAdding: .minute, value: workHoursInMinutes, to: now)
        }

        guard let endDate = endDateAddingHours(hours: workHours) else {
            Log.log(.error, "")
            return
        }

        let components = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: endDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let req = UNNotificationRequest(identifier: "ArrivedAtWork", content: content, trigger: trigger)

        let current = UNUserNotificationCenter.current()
        current.add(req, withCompletionHandler: nil)
        // TODO: Add Logging

        // TODO: Can we add a delivery handler, to log when the notifiation is finally shown?
    }

    func handleDepartedWork() {
        // cancel any scheduled notifications
        let current = UNUserNotificationCenter.current()
        current.removeAllPendingNotificationRequests()
        // TODO: Add Logging Here
    }

}
