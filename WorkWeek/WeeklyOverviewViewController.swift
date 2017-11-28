//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MXSegmentedPager


class WeeklyOverviewViewController: MXSegmentedPagerController, WeeklyGraphViewDelegate {

    var weekObject: WeeklyObject!
    static let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]


    lazy var controllersArray: [(title: String, controller: UIViewController)] = {
        var array: [(title: String, controller: UIViewController)] = []

        func addpage(_ title: String, controller: UIViewController) {
            self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)
            array.append((title, controller))
        }

        for day in WeeklyOverviewViewController.daysOfWeek {
            addpage(day, controller: DayViewController())
        }

        return array
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return getThemeStatusBarStyle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()

        let nib = UINib(nibName: "WeeklyGraphView", bundle: nil)
        let headerView = nib.instantiate(withOwner: WeeklyGraphView.self, options: nil)[0] as? WeeklyGraphView
        let viewModel = WeeklyGraphViewModel.init(weekObject)

        headerView?.configure(viewModel)
        headerView?.delegate = self

        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.center
        segmentedPager.parallaxHeader.height = 400
        segmentedPager.parallaxHeader.minimumHeight = 0
    }


    // MARK: WeeklyGraphViewDelegate

    func didTapDay(_ index: Int) {
        segmentedPager.pager.showPage(at: index, animated: true)
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
