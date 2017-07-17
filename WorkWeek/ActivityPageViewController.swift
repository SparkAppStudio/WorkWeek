//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation


protocol ActivityPageViewDelegate: class {
    func pageDidTapSettings()
}

final class ActivityPageViewController: UIPageViewController, ActivityStoryboard, CountdownViewDelegate {

    lazy var manager: PageManager = {
        return PageManager(viewControllers: self.configOrderedViewControllers())
    }()

    weak var activityDelegate: ActivityPageViewDelegate?
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = .white
        self.removePageViewControllerBlackEmptyBackground()
    }

    func configOrderedViewControllers() -> [UIViewController] {
        let countdownVC = CountdownViewController.instantiate()
        countdownVC.delegate = self
        let dailyVC = DailyCollectionViewController.instantiate()
        let weeklyVC = WeeklyCollectionViewController.instantiate()

        return [countdownVC, dailyVC, weeklyVC]
    }

    func countdownPageDidTapSettings() {
        activityDelegate?.pageDidTapSettings()
    }
}

extension UIPageViewController {
    func removePageViewControllerBlackEmptyBackground() {
        for subview in self.view.subviews where subview is UIScrollView {
            subview.frame = view.frame
        }
    }
}
