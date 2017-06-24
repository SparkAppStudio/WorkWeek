//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

class ActivityPageViewController: UIPageViewController, ActivityStoryboard {

    var orderedViewControllers = [
        CountdownViewController.instantiate(),
        DailyTableViewController.instantiate(),
        WeeklyTableViewController.instantiate()
    ]

    lazy var manager: PageManager = {
        return PageManager(viewControllers: self.orderedViewControllers)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = manager
        dataSource = manager

        guard let firstVC = orderedViewControllers.first else {
            assertionFailure("No pages in array")
            return
        }

        setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.removePageViewControllerBlackEmptyBackground()
    }
}

extension UIPageViewController {
    func removePageViewControllerBlackEmptyBackground() {
        for subview in self.view.subviews where subview is UIScrollView {
            subview.frame = view.frame
        }
    }
}
