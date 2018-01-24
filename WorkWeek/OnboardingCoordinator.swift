//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnboardingCoordinatorDelegate: class {
    func onboardingFinished(with coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator: OnboardPageViewDelegate, MapVCDelegate, UserGettable {

    var vcForPresentation: UIViewController {
        return navigationController
    }

    var currentUser: User!
    let navigationController: UINavigationController
    let locationManager: CLLocationManager
    weak var delegate: OnboardingCoordinatorDelegate?

    init(with navController: UINavigationController,
         manger: CLLocationManager,
         delegate: OnboardingCoordinatorDelegate) {

        self.navigationController = navController
        self.locationManager = manger
        self.delegate = delegate
    }

    func start() {
        Log.log()
        let onboardVC = OnboardPageViewController.instantiate()
        onboardVC.onboardDelegate = self
        onboardVC.locationManager = locationManager

        navigationController.setViewControllers([onboardVC], animated: false)
        navigationController.isNavigationBarHidden = true

        guard let user = getUserFromRealm() else {
            showErrorAlert()
            return
        }
        currentUser = user
    }

    func pagesAreDone() {
        delegate?.onboardingFinished(with: self)
    }

    func pageDidTapHome() {
        locationManager.startUpdatingLocation()
        SettingsMapViewController.presentMapWith(navController: navigationController,
                                       as: .home,
                                       location: locationManager,
                                       delegate: self, user: currentUser)
    }

    func pageDidTapWork() {
        locationManager.startUpdatingLocation()
        SettingsMapViewController.presentMapWith(navController: navigationController,
                                       as: .work,
                                       location: locationManager,
                                       delegate: self, user: currentUser)
    }
}
