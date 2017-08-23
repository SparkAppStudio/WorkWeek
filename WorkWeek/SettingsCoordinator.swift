//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol SettingsCoordinatorDelegate: class {
    func settingsFinished(with coordinator: SettingsCoordinator)
}

class SettingsCoordinator: SettingsMainProtocol, MapVCDelegate {

    /// The app's navigation controller on which to present content
    let navigationController: UINavigationController

    /// Location manager is required to set the users home and work region
    let locationManager: CLLocationManager

    /// The delegate to call when the user is finished with settings
    weak var delegate: SettingsCoordinatorDelegate?

    /// The user whose Settings should be modified
    let user: User

    init(with navController: UINavigationController,
         manger: CLLocationManager,
         user: User,
         delegate: SettingsCoordinatorDelegate) {

        self.navigationController = navController
        self.locationManager = manger
        self.user = user
        self.delegate = delegate
    }

    lazy var settingsNavController: UINavigationController = {
        let settingsVC = SettingsViewController.instantiate()
        settingsVC.delegate = self
        settingsVC.user = self.user
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        return settingsNavController
    }()

    func start() {
        Log.log()

        navigationController.isNavigationBarHidden = true
        navigationController.present(settingsNavController, animated: true, completion: nil)
    }

    // MARK: Settings Main Protocol

    // TODO: Remove Navigation Parameter from these 3 calls
    func didTapHomeMap(nav: UINavigationController) {
        SettingsMapViewController.presentMapWith(navController: nav,
                                       as: .home,
                                       location: locationManager,
                                       delegate: self)
    }

    func didTapWorkMap(nav: UINavigationController) {
        SettingsMapViewController.presentMapWith(navController: nav,
                                       as: .work,
                                       location: locationManager,
                                       delegate: self)
    }

    func didTapSelectHours(nav: UINavigationController) {
        let pickerVC = HoursPickerViewController.instantiate()
        pickerVC.delegate = self
        pickerVC.user = user
        nav.present(pickerVC, animated: true, completion: nil)
    }

    func didTapDone() {
        Log.log("User tapped one on Main Settings")
        navigationController.dismiss(animated: true, completion: nil)
        delegate?.settingsFinished(with: self)
    }
}

extension SettingsCoordinator: HoursPickerDelegate {
    func pickerFinished(pickerVC: UIViewController) {
        pickerVC.dismiss(animated: true, completion: nil)
    }
}
