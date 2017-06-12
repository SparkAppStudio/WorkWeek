//
//  OnboardPageViewController.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 6/3/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

final class OnboardPageViewController: UIPageViewController, OnboardingStoryboard {

    var orderedViewControllers = [OnboardGreenViewController.instantiate(),
                        OnboardBlueViewController.instantiate(),
                        OnboardOrangeViewController.instantiate()]

    lazy var manager: PageManager = {
        return PageManager(types: self.orderedViewControllers)
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
}
