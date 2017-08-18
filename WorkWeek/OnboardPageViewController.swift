//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnboardPageViewDelegate: class {
    func pageDidTapHome()
    func pageDidTapWork()
    func pagesAreDone()
}

final class OnboardPageViewController: UIPageViewController, OnboardingStoryboard,
    OnboardLocationViewDelegate, OnboardNotifyViewDelegate, OnboardSettingsViewDelegate {

    lazy var manager: PageManager = {
        return PageManager(viewControllers: self.configOrderedViewControllers())
    }()

    weak var onboardDelegate: OnboardPageViewDelegate?
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureGradient()

        delegate = manager
        dataSource = manager

        guard let firstVC = manager.orderedViewControllers.first else {
            assertionFailure("No pages in array")
            return
        }

        setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
    }

    func configureGradient() {
        let rect = view.bounds
        let gradient = GradientBackgroundView(frame: rect)
        view.insertSubview(gradient, at: 0)
    }

    func configOrderedViewControllers() -> [UIViewController] {
        let welcomeVC = OnboardWelcomeViewController.instantiate()
        let explainVC = OnboardExplainViewController.instantiate()
        let locationVC = OnboardLocationViewController.instantiate()
        locationVC.locationManager = locationManager
        locationVC.delegate = self

        return [welcomeVC, explainVC, locationVC]

    }

    func locationPageIsDone() {
        //inject notify page if it doesnt already exist
        if manager.orderedViewControllers.count < 4 {
            DispatchQueue.main.async {

                let settingsVC = OnboardSettingsViewController.instantiate()
                settingsVC.delegate = self

                let notifyVC = OnboardNotifyViewController.instantiate()
                notifyVC.delegate = self

                // update the datasource
                self.manager.orderedViewControllers.append(settingsVC)
                self.manager.orderedViewControllers.append(notifyVC)

                // start the view controllers after datasource has been updated, 
                // and start the user at the 3rd page, which is current one they are looking at
                self.setViewControllers([self.manager.orderedViewControllers[2]], direction: .forward, animated: false, completion: nil)
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func settingsPageDidTapHome() {
        onboardDelegate?.pageDidTapHome()
    }

    func settingsPageDidTapWork() {
        onboardDelegate?.pageDidTapWork()
    }

    func notifyPageIsDone() {
        onboardDelegate?.pagesAreDone()
    }
}
