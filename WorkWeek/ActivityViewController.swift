//
//  TodayViewController.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 9/28/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MXSegmentedPager

class ActivityViewController: MXSegmentedPagerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ActivityHeaderView", bundle: nil)
        let headerView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView // swiftlint:disable:this force_cast

        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.fill
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
        return 1
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return "title"
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = HistoryTableViewController(style: .plain)
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        return vc
    }
}
