//  Created by YupinHuPro on 6/3/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

class ActivityPageViewController: UIPageViewController {
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("CountdownViewController"),
                self.newViewController("DailyTableViewController"),
                self.newViewController("WeeklyTableViewController")]
    }()
    fileprivate func newViewController(_ vcName: String) -> UIViewController {
        return UIStoryboard(name: "Activity", bundle: nil) .
            instantiateViewController(withIdentifier: vcName)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        // Loading up the first page
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

}
extension ActivityPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
}
extension ActivityPageViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Activity", bundle: nil)
}
