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

    // MARK: Settings Main Protocol

    func didTapHomeMap() {
        locationManager.startUpdatingLocation()
        SettingsMapViewController.push(onto: navigationController,
                                       as: .home,
                                       location: locationManager,
                                       delegate: self)
    }

    func didTapWorkMap() {
        locationManager.startUpdatingLocation()
        SettingsMapViewController.push(onto: navigationController,
                                       as: .work,
                                       location: locationManager,
                                       delegate: self)
    }

    func notificationsSwitched(_ isOn: Bool) {
        let state = isOn ? "ON" : "OFF"
        Log.log("switched notifications to \(state)")
    }

    func didTapDone() {
        Log.log("User tapped one on Main Settings")
        delegate?.settingsFinished(with: self)
    }

}

protocol SettingsMainProtocol: class {
    func didTapWorkMap()
    func didTapHomeMap()
    func notificationsSwitched(_ isOn: Bool)
    func didTapDone()
}
