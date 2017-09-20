//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation

struct CountDown: CountdownData {
    var timeLeftInDay: TimeInterval {
        return RealmManager.shared.getUserTimeLeft()
    }
    var timeLeftInWeek: TimeInterval {
        let weekly = RealmManager.shared.queryWeeklyObject(for: Date())!
        return weekly.totalWorkTime
    }
}

final class ActivityPageViewController: UIPageViewController, ActivityStoryboard {

    var orderedViewControllers: [UIViewController]!

    lazy var manager: PageManager = {
        return PageManager(viewControllers: orderedViewControllers)
    }()

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
