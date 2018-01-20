//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

/// This class draw a line with a percentage that's
/// proportional to the view

class GraphTargetLine: UIView {

    /// When none of the days is higher than user work day hours,
    /// the percentage is 0.6 to be consistent with design
    /// When there exist a day worked more than default user work
    /// day hours, percentage equals to defaultUserWorkHour/max

    public var targetData: (percent: Double, hours: String) = (0.6, "") {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.white.cgColor)
        let myHeight = rect.height
        let lineHeight = myHeight * (1.0 - CGFloat(targetData.percent))
        let startPoint = CGPoint(x: 0, y: lineHeight)
        let endPoint = CGPoint(x: rect.width-30, y: lineHeight)
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.setSparkShadow()
        context.strokePath()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.themeText()
        label.textAlignment = .left
        label.font = label.font.withSize(10)
        label.text = targetData.hours
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.addSubview(label)
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
        label.centerYAnchor.constraint(equalTo: self.topAnchor, constant: lineHeight-2).isActive = true
    }
}
