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
        let settingsNavController = UINavigationController(rootViewController: settingsVC)

        navigationController.present(settingsNavController, animated: true, completion: nil)
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

    func didTapDone() {
        Log.log("User tapped one on Main Settings")
        navigationController.dismiss(animated: true, completion: nil)
        delegate?.settingsFinished(with: self)
    }

}

@IBDesignable
class TwoLabelButton: UIButton {

    let right: UILabel = {
        let l = UILabel(frame: .zero)
        l.textAlignment = .right
        return l
    }()

    let left: UILabel = {
        let l = UILabel(frame: .zero)
        l.textAlignment = .left
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    var stack: UIStackView!

    func sharedInit() {

        self.setTitle(nil, for: .normal)
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.stack = stack
        stack.alignment = .center
        stack.distribution = .fillProportionally
        self.addSubview(stack)

        right.text = "8.0"
        left.text = "Target Hours Per Day"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
