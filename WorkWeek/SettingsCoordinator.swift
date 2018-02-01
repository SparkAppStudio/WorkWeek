//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

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

    private var settingsVC: SettingsViewController?
    private var userUpdatedToken: NotificationToken?

    init(with navController: UINavigationController,
         manger: CLLocationManager,
         user: User,
         delegate: SettingsCoordinatorDelegate) {

        self.navigationController = navController
        self.locationManager = manger
        self.user = user
        self.delegate = delegate
        configureNotificationsForUserChanges()
    }

    lazy var settingsNavController: UINavigationController = {
        let settingsVC = SettingsViewController.instantiate()
        settingsVC.delegate = self
        settingsVC.user = self.user
//        settingsVC.day = DataStore.shared.queryDailyObject()
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        self.settingsVC = settingsVC //save a copy for later
        return settingsNavController
    }()

    func start() {
        Log.log()

        navigationController.isNavigationBarHidden = true
        navigationController.present(settingsNavController, animated: true, completion: nil)
    }

    func configureNotificationsForUserChanges() {
        userUpdatedToken = user.observe { [weak self] change in
            switch change {
            case .change(let properties):
                if let hours = properties.first(where: { $0.name == "hoursInWorkDay" }),
                    let hoursNumber = hours.newValue as? Double {
                    self?.settingsVC?.updateUserHours(hours: "\(hoursNumber)")
                }
            default:
                return
            }
        }
    }


    // MARK: Settings Main Protocol

    // TODO: Remove Navigation Parameter from these 3 calls
    func didTapHomeMap(nav: UINavigationController) {

       let day = DataStore.shared.queryDailyObject()
        SettingsMapViewController.presentMapWith(navController: nav,
                                       as: .home,
                                       location: locationManager,
                                       delegate: self, user: user,
                                       day: day)
    }

    func didTapWorkMap(nav: UINavigationController) {

        let day = DataStore.shared.queryDailyObject()

 SettingsMapViewController.presentMapWith(navController: nav,
                                       as: .work,
                                       location: locationManager,
                                       delegate: self, user: user,
                                       day: day)
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
