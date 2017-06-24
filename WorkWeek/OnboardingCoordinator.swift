//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnboardingCoordinatorDelegate : class {
    func onboardingFinished(with coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator {

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
        let initial = OnboardPageViewController.instantiate()
        navigationController.setViewControllers([initial], animated: false)
        navigationController.isNavigationBarHidden = true
    }

    func notificationsPageIsFinished() {
        delegate?.onboardingFinished(with: self)
    }
}


