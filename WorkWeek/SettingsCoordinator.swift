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

        guard let user = getUserFromRealm() else {
            showErrorAlert()
            return
        }

        navigationController.isNavigationBarHidden = true

        let settingsVC = SettingsViewController.instantiate()
        settingsVC.delegate = self
        settingsVC.user = user
        navigationController.pushViewController(settingsVC, animated: false)
    }

    func getUserFromRealm() -> User? {
        RealmManager.shared.saveInitialUser()
        return RealmManager.shared.queryAllObjects(ofType: User.self).first
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "🤔Error🤔",
                                      message: "Looks like something has gone wrong with our database. Press \"OK\" to restart",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            fatalError()
        }

        alert.addAction(ok)
        navigationController.present(alert, animated: true, completion: nil)
    }


    // MARK: Settings Main Protocol

    func didTapHomeMap() {
        SettingsMapViewController.push(onto: navigationController,
                                       as: .home,
                                       location: locationManager,
                                       delegate: self)
    }

    func didTapWorkMap() {
        SettingsMapViewController.push(onto: navigationController,
                                       as: .work,
                                       location: locationManager,
                                       delegate: self)
    }

    func didTapDone() {
        Log.log("User tapped one on Main Settings")
        delegate?.settingsFinished(with: self)
    }

}
