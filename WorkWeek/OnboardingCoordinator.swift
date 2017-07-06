//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnboardingCoordinatorDelegate : class {
    func onboardingFinished(with coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator: OnboardPageViewDelegate, MapVCDelegate {

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
        Log.log("\(#file): \(#function)")
        let initial = OnboardPageViewController.instantiate()
        initial.onboardDelegate = self

        navigationController.setViewControllers([initial], animated: false)
        navigationController.isNavigationBarHidden = true
    }

    func pagesAreDone() {
        delegate?.onboardingFinished(with: self)
    }

    func pageDidTapHome() {
        locationManager.startUpdatingLocation()
        SettingsMapViewController.push(onto: navigationController,
                                       as: .home,
                                       location: locationManager,
                                       delegate: self)
    }

    func pageDidTapWork() {
        locationManager.startUpdatingLocation()
        SettingsMapViewController.push(onto: navigationController,
                                       as: .work,
                                       location: locationManager,
                                       delegate: self)
    }
}
