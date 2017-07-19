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

        delegate = manager
        dataSource = manager

        guard let firstVC = manager.orderedViewControllers.first else {
            assertionFailure("No pages in array")
            return
        }

        setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sparkBlue = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        self.view.backgroundColor = sparkBlue
        extendPageViewContent(view: view)
    }

    func extendPageViewContent(view: UIView) {
        // Iterate through subviews and make their frame as tall as this controller frame.
        // This stretches the content below the pageVC controls (the dots) and covers the black empty background
        // make the widths extra wide and create offset for origin so its still centered. This hides the black when scrolling with a bounce
        // width is *2 the width because that is maximum they could swipe slowly 
        // and so this way they will not see the page view background color
        for subview in view.subviews where subview is UIScrollView {

            let wideSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
            let offsetOrigin = CGPoint(x: -view.frame.width / 2, y: view.frame.origin.y)
            let subviewFrame = CGRect(origin: offsetOrigin, size: wideSize)

            subview.frame = subviewFrame
        }
    }
}
