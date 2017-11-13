//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

/// This class draw a line with a percentage that's
/// proportional to the view

class GraphTargetLine: UIView {

    /// When non of the days is higher than user work day hours,
    /// the percentage is 1
    /// When there exist a day worked more than default user work
    /// day hours, percentage equals to defaultUserWorkHour/max

    public var percentage: Double = 0.6 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(3)
        context.setStrokeColor(UIColor.white.cgColor)
        let myHeight = rect.height
        let lineHeight = myHeight * (1.0 - CGFloat(percentage))
        context.move(to: CGPoint(x: 0, y: lineHeight))
        context.addLine(to: CGPoint(x: rect.width, y: lineHeight))
        context.strokePath()
    }
}
