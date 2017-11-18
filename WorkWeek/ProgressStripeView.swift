//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class ProgressStripeView: UIView {

    public var percentage: Double?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        guard let percent = percentage else { return }
        let context = UIGraphicsGetCurrentContext()!

        let progressHeight = CGFloat(percent) * rect.height
        let div = rect.divided(atDistance: progressHeight, from: CGRectEdge.maxYEdge)

        context.clip(to: div.slice)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: NSArray = [UIColor.dailyGraphGreen().cgColor, UIColor.workBlue().cgColor]
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors,
                                        locations: [0, 1]) else { return }
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: div.slice.size.width, y: div.slice.size.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

    }

}
