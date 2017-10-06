//
//  TodayViewController.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 9/28/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MXSegmentedPager


class WeeklyOverviewViewController: MXSegmentedPagerController {

    var controllersArray = [(String, UIViewController)]()
    var daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    override func viewDidLoad() {
        super.viewDidLoad()

        for day in daysOfWeek {
            addpage(day, controller: DailyCollectionViewController.instantiate())
        }

        let nib = UINib(nibName: "ActivityHeaderView", bundle: nil)
        let headerView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView // swiftlint:disable:this force_cast

        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.fill
        segmentedPager.parallaxHeader.height = 400
        segmentedPager.parallaxHeader.minimumHeight = 0
    }

    func addpage(_ title: String, controller: UIViewController) {
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        controllersArray.append((title, controller))
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
        return controllersArray[index].0 //0 is first item in tuple which is a string
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {

        return controllersArray[index].1 //1 is the second item in tuple which is uiviewcontroller
    }
}
