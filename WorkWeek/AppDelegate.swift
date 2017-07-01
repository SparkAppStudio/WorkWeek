//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

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

}
