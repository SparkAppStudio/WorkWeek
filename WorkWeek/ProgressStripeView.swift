//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class ProgressStripeView: UIView {

    public var workData: (percent: Double, hours: String)!
    public var isToday: Bool?

    var pointForLabel: CGPoint!
    var heightForLabel: CGFloat = 15

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        let progressHeight = CGFloat(workData.percent) * rect.height
        let div = rect.divided(atDistance: progressHeight, from: CGRectEdge.maxYEdge)

        context.clip(to: div.slice)
        context.setSparkShadow()

        let startPoint = CGPoint(x: 0, y: div.remainder.height)
        pointForLabel = CGPoint(x: 0, y: div.remainder.height - heightForLabel)
        let endPoint = CGPoint(x: 0, y: rect.height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var colors: NSArray = [UIColor.dailyGraphGreen().cgColor, UIColor.workBlue().cgColor]

        if isToday != nil {
             colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        }
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors,
                                        locations: [0, 1]) else { return }
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }

}

protocol ProgressStripeViewDelegate: class {
    func didTapDay(_ index: Int)
}

class TouchableProgressStripeView: ProgressStripeView {

    weak var delegate: ProgressStripeViewDelegate!
    var index: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let frame = CGRect(origin: pointForLabel, size: CGSize(width: rect.width, height: heightForLabel))
        let label = UILabel(frame: frame)
        label.textColor = UIColor.themeText()
        label.textAlignment = .center
        label.font = label.font.withSize(9)
        label.text = workData.hours
        self.addSubview(label)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        delegate.didTapDay(index)
    }

}
