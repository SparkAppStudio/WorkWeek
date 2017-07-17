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
        Log.log()

        navigationController.isNavigationBarHidden = true

        let initial = SettingsViewController.instantiate()
        initial.delegate = self

        let settingsNavController = UINavigationController(rootViewController: initial)

        navigationController.present(settingsNavController, animated: true, completion: nil)
    }

    // MARK: Settings Main Protocol

    func didTapHomeMap(nav: UINavigationController) {
        SettingsMapViewController.push(onto: nav,
                                       as: .home,
                                       location: locationManager,
                                       delegate: self)
    }

    func didTapWorkMap(nav: UINavigationController) {
        SettingsMapViewController.push(onto: nav,
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
        navigationController.dismiss(animated: true, completion: nil)
        delegate?.settingsFinished(with: self)
    }

}
