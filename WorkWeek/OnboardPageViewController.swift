//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

protocol OnboardPageViewDelegate: class {
    func pagesAreDone()
}

final class OnboardPageViewController: UIPageViewController, OnboardingStoryboard, OnboardLocationViewDelegate, OnboardNotifyViewDelegate {

    lazy var manager: PageManager = {
        return PageManager(viewControllers: self.configOrderedViewControllers())
    }()

    weak var onboardDelegate: OnboardPageViewDelegate?

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
        locationVC.delegate = self
        let notifyVC = OnboardNotifyViewController.instantiate()
        notifyVC.delegate = self

        return [welcomeVC, explainVC, locationVC, notifyVC]

    }

    func locationPageIsDone() {
        //inject notify page
    }

    func notifyPageIsDone() {
        onboardDelegate?.pagesAreDone()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        extendPageViewContent(view: view)
    }

    func extendPageViewContent(view: UIView) {
        // Iterate through subviews and make their frame as big as this controller frame.
        // This stretches the content below the pageVC controls (the dots) and covers the black empty background
        for subview in view.subviews where subview is UIScrollView {
            subview.frame = view.frame
        }
    }
}
