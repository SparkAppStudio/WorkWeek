//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class PageManager: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var orderedViewControllers: [UIViewController]

    init(viewControllers: [UIViewController]) {
        orderedViewControllers = viewControllers
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        preventBounce(pageViewController: pageViewController)

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0, orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {

        preventBounce(pageViewController: pageViewController)

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else {
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

    // Used to Prevent user from swiping toward the edge and seeing black background behind.
    // This is done for every page, 
    // as black background can be seen between if user swipes aggressively
    // TODO: This doesn't actually work, however moving it to the pageVC itself breaks scrolling altogether
    func preventBounce(pageViewController: UIPageViewController) {
        // Iterate through the views looking for scroll view
        // (which is the view that controls the pages swiping and bounce)
        // and disable bounce
        for subview in pageViewController.view.subviews where subview is UIScrollView {
            guard let view = subview as? UIScrollView else {break}
            view.bounces = false
        }
    }
}
