//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol SettingsCoordinatorDelegate: class {
    func settingsFinished(with coordinator: SettingsCoordinator)
}

class SettingsCoordinator: SettingsMainProtocol, MapVCDelegate {

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
        Log.log("\(#file): \(#function)")

        navigationController.isNavigationBarHidden = true

        let initial = SettingsViewController.instantiate()
        initial.delegate = self
        navigationController.pushViewController(initial, animated: false)
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
        checkLocation()
        locationManager.startUpdatingLocation()
        pushMapVC(type: .home, delegate: self, onto: navigationController)
    }

    func didTapWorkMap() {
        checkLocation()
        locationManager.startUpdatingLocation()
        pushMapVC(type: .work, delegate: self, onto: navigationController)
    }

    func notificationsSwitched(_ isOn: Bool) {
        let state = isOn ? "ON" : "OFF"
        Log.log("switched notifications to \(state)")
    }

    private func pushMapVC(type: MapVCType, delegate: MapVCDelegate, onto: UINavigationController) {
        let mapViewController = SettingsMapViewController.instantiate()
        mapViewController.locationManager = locationManager
        mapViewController.type = type
        mapViewController.delegate = delegate
        onto.pushViewController(mapViewController, animated: true)
    }

    // TODO: We'll probably want to write a little wrapper, that hangs off the app coordinator
    private func checkLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .denied, .restricted, .authorizedWhenInUse:
            presentOurAppWontWorkWithoutAuthorizationModalSheet()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        }
    }

    // MARK: MapVCDelegate

    func save(type: MapVCType, coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let region: CLRegion
        switch type {
        case .home:
            region = CLCircularRegion(center: coordinate, radius: radius, identifier: RegionId.home.rawValue)
        case .work:
            region = CLCircularRegion(center: coordinate, radius: radius, identifier: RegionId.work.rawValue)
        }
        locationManager.startMonitoring(for: region)
        navigationController.popViewController(animated: true)
    }

    func cancel() {
        navigationController.popViewController(animated: true)
    }

}

protocol SettingsMainProtocol: class {
    func didTapWorkMap()
    func didTapHomeMap()
    func notificationsSwitched(_ isOn: Bool)
}
