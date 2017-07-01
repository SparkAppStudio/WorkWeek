//
//  NavigationController+Extensions.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 7/1/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popWithModalAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        self.popViewController(animated: false)
    }
}
