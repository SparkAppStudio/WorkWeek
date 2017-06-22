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

        navigationController.setViewControllers([initial], animated: false)
        navigationController.isNavigationBarHidden = true
    }

    enum MapConfig {
        case home
        case work
    }

    // MARK: Settings Main Protocol

    func didTapHomeMap() {
        print("Tapped Home Map")
    }

    func didTapWorkMap() {
        print("Tapped Work Map")
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
