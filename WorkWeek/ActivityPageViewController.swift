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
        changePageIndicatorColor()
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
        countdownVC.title = "Count Down"
        let navCountdownVC = UINavigationController(rootViewController: countdownVC)
        countdownVC.delegate = self

        let dailyVC = DailyCollectionViewController.instantiate()
        dailyVC.title = "Daily Activity"
        let navDailyVC = UINavigationController(rootViewController: dailyVC)
        let weeklyVC = WeeklyCollectionViewController.instantiate()
        weeklyVC.title = "Weekly Report"
        let navWeeklyVC = UINavigationController(rootViewController: weeklyVC)

        return [navCountdownVC, navDailyVC, navWeeklyVC]
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

    func changePageIndicatorColor() {
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.lightGray
        proxy.currentPageIndicatorTintColor = UIColor.green
    }
}
