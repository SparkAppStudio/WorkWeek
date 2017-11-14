//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MXSegmentedPager


class WeeklyOverviewViewController: MXSegmentedPagerController {

    lazy var controllersArray: [(title: String, controller: UIViewController)] = {
        var array: [(title: String, controller: UIViewController)] = []
        let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        func addpage(_ title: String, controller: UIViewController) {
            self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)
            array.append((title, controller))
        }

        for day in daysOfWeek {
            addpage(day, controller: DailyCollectionViewController.instantiate())
        }

        return array
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()

        let nib = UINib(nibName: "WeeklyGraphView", bundle: nil)
        let headerView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView // swiftlint:disable:this force_cast

        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.center
        segmentedPager.parallaxHeader.height = 400
        segmentedPager.parallaxHeader.minimumHeight = 0
    }


    // MARK: MXSegmentedPagerDelegate

    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 0
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        if parallaxHeader.progress > 0.2 {
            //implement pull to refresh here
        }
    }


    // MARK: MXSegmentedPagerDataSource

    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return controllersArray.count
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return controllersArray[index].title
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {

        return controllersArray[index].controller
    }
}
