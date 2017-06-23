//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class SettingsCoordinator: SettingsMainProtocol {

    let navigationController: UINavigationController

    init(with navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        let initial = SettingsViewController.instantiate()
        initial.delegate = self

        navigationController.pushViewController(initial, animated: false)
        initial.title = NSLocalizedString("Settings", comment: "Setings page title")
    }


    // MARK: Settings Main Protocol

    func didTapHomeMap() {
        let mapViewController = SettingsMapViewController.instantiate()
        navigationController.isNavigationBarHidden = false
        mapViewController.title = NSLocalizedString("Home", comment: "Settings Map Set Home Location")
        navigationController.pushViewController(mapViewController, animated: true)
    }

    func didTapWorkMap() {
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
