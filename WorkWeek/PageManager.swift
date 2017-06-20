//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class PageManager: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {


    init(types: [UIViewController]) {
        orderedViewControllers = types
    }

    var orderedViewControllers: [UIViewController]


    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0, orderedViewControllers.count > previousIndex else {
            for subview in pageViewController.view.subviews where subview is UIScrollView {
                guard let view = subview as? UIScrollView else {break}
                view.bounces = false
            }

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

        guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else {
            for subview in pageViewController.view.subviews where subview is UIScrollView {
                guard let view = subview as? UIScrollView else {break}
                view.bounces = false
            }
            return nil
        }

        return orderedViewControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: currentViewController) else {
                return 0
        }
        return currentIndex
    }
}
