//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol SettingsCoordinatorDelegate: class {
    func settingsFinished(with coordinator: SettingsCoordinator)
}

class SettingsCoordinator: SettingsMainProtocol {

    let navigationController: UINavigationController
    let locationManager: CLLocationManager
    weak var delegate: SettingsCoordinatorDelegate?

    init(with navController: UINavigationController,
         manger: CLLocationManager,
         delegate: SettingsCoordinatorDelegate) {

        self.navigationController = navController
        self.locationManager = manger
        self.delegate = delegate
    }

    func start() {
        let initial = SettingsViewController.instantiate()
        initial.delegate = self

        navigationController.pushViewController(initial, animated: false)
        initial.title = NSLocalizedString("Settings", comment: "Setings page title")
    }

    // TODO: Move this UP (probably location auth should be handled by the app coordinator)
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

        // TODO: We'll probably want to write a little wrapper, that hangs off the app coordinator
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .denied, .restricted, .authorizedWhenInUse:
            presentOurAppWontWorkWithoutAuthorizationModalSheet()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.startUpdatingLocation()

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

        locationManager.startUpdatingLocation()

        let mapViewController = SettingsMapViewController.instantiate()
        navigationController.isNavigationBarHidden = false
        mapViewController.title = NSLocalizedString("Work", comment: "Settings Map Set Work Location")
        navigationController.pushViewController(mapViewController, animated: true)
    }

    func notificationsSwitched(_ isOn: Bool) {
        let state = isOn ? "ON" : "OFF"
        Log.log("switched notifications to \(state)")
    }

}

protocol SettingsMainProtocol: class {
    func didTapWorkMap()
    func didTapHomeMap()
    func notificationsSwitched(_ isOn: Bool)
}
