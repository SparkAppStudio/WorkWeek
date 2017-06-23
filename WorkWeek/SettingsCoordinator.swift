//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsCoordinator: SettingsMainProtocol {

    let navigationController: UINavigationController
    let locationManager: CLLocationManager

    init(with navController: UINavigationController, manger: CLLocationManager) {
        self.navigationController = navController
        self.locationManager = manger
    }

    func start() {
        let initial = SettingsViewController.instantiate()
        initial.delegate = self

        navigationController.pushViewController(initial, animated: false)
        initial.title = NSLocalizedString("Settings", comment: "Setings page title")
    }

    func presentOurAppWontWorkWithoutAuthorizationModalSheet() {
        let sorryMessage = "Due to technical limitations our app can't work without Always Location"
        let alertController = UIAlertController(title: "Sorry...",
                                                message: sorryMessage,
                                                preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settings = UIAlertAction(title: "Fix It", style: .default) { _ in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(cancelButton)
        alertController.addAction(settings)
        navigationController.present(alertController, animated: true, completion: nil)
    }


    // MARK: Settings Main Protocol

    func didTapHomeMap() {

        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .denied, .restricted, .authorizedWhenInUse:
            presentOurAppWontWorkWithoutAuthorizationModalSheet()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        }

        let mapViewController = SettingsMapViewController.instantiate()
        navigationController.isNavigationBarHidden = false
        mapViewController.title = NSLocalizedString("Home", comment: "Settings Map Set Home Location")
        navigationController.pushViewController(mapViewController, animated: true)
    }

    func didTapWorkMap() {

        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .denied, .restricted, .authorizedWhenInUse:
            presentOurAppWontWorkWithoutAuthorizationModalSheet()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        }

        let mapViewController = SettingsMapViewController.instantiate()
        navigationController.isNavigationBarHidden = false
        mapViewController.title = NSLocalizedString("Work", comment: "Settings Map Set Work Location")
        navigationController.pushViewController(mapViewController, animated: true)
    }

    func notificationsSwitched(_ isOn: Bool) {
        let state = isOn ? "ON" : "OFF"
        print("switched notifications to \(state)")
    }

}

protocol SettingsMainProtocol: class {
    func didTapWorkMap()
    func didTapHomeMap()
    func notificationsSwitched(_ isOn: Bool)
}
