//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnboardingCoordinatorDelegate : class {
    func onboardingFinished(with coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator: OnboardPageViewDelegate {

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
        let initial = OnboardPageViewController.instantiate()
        initial.onboardDelegate = self

        navigationController.setViewControllers([initial], animated: false)
        navigationController.isNavigationBarHidden = true
    }

    func pagesAreDone() {
        delegate?.onboardingFinished(with: self)
    }
}
