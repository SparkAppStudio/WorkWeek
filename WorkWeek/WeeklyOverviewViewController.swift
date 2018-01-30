//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MXSegmentedPager


class WeeklyOverviewViewController: MXSegmentedPagerController, WeeklyGraphViewDelegate, DayViewControllerDelegate {

    var weekObject: WeeklyObject!
    static let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var headerView: WeeklyGraphView!

    lazy var controllersArray: [(title: String, controller: UIViewController)] = {
        var array: [(title: String, controller: UIViewController)] = []

        func addpage(_ title: String, controller: UIViewController) {
            self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)
            array.append((title, controller))
        }

        for (index, day) in WeeklyOverviewViewController.daysOfWeek.enumerated() {
            let dayVC = DayViewController()
            dayVC.dayText = day
            dayVC.delegate = self
            for dayObject in weekObject.dailyObjects {
                guard let weekDay = dayObject.weekDay else { continue }
                if weekDay == index+1 {
                    dayVC.dayObject = dayObject
                }
            }

            addpage(day, controller: dayVC)
        }

        return array
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme(isNavBarTransparent: false)

        let nib = UINib(nibName: "WeeklyGraphView", bundle: nil)
        headerView = nib.instantiate(withOwner: WeeklyGraphView.self, options: nil)[0] as? WeeklyGraphView
        let viewModel = WeeklyGraphViewModel.init(weekObject)

        headerView?.configure(viewModel)
        headerView?.delegate = self

        // Parallax Header

        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.center
        segmentedPager.parallaxHeader.height = 222 // to match WeeklyGraphView xib
        segmentedPager.parallaxHeader.minimumHeight = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectDay(at: nil)
    }

    func selectDay(at index: Int?) {
        if let index = index {
            let label = headerView?.dayLabels[index]
            label?.textColor = UIColor.workBlue()
        } else {
            let label = headerView?.dayLabels[segmentedPager.pager.indexForSelectedPage]
            label?.textColor = UIColor.workBlue()
        }
    }

    func deselectDay(at index: Int?) {
        if let index = index {
            let label = headerView?.dayLabels[index]
            label?.textColor = UIColor.themeText()
        } else {
            let label = headerView?.dayLabels[segmentedPager.pager.indexForSelectedPage]
            label?.textColor = UIColor.themeText()
        }
    }

    // MARK: MXSegmentedPagerDelegate

    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 0
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
        for i in 0...6 {
            deselectDay(at: i)
        }
        selectDay(at: index)
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


    // MARK: WeeklyGraphViewDelegate

    func didTapDay(_ index: Int) {
        segmentedPager.pager.showPage(at: index, animated: true)
    }


    // MARK: DayViewControllerDelegate

    func headerDidTapLeft(_ sender: UIButton) {
        let previousIndex = segmentedPager.pager.indexForSelectedPage - 1
        segmentedPager.pager.showPage(at: previousIndex, animated: true)
    }

    func headerDidTapRight(_ sender: UIButton) {
        let nextIndex = segmentedPager.pager.indexForSelectedPage + 1
        segmentedPager.pager.showPage(at: nextIndex, animated: true)
    }
}
