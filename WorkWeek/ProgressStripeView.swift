//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class ProgressStripeView: UIView {

    public var percentage: Double?
    private var color = UIColor(red: 54/255, green: 236/255, blue: 80/255, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.white
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let percent = percentage else { return }
        let context = UIGraphicsGetCurrentContext()!
        let fillColor = color.cgColor
        context.setFillColor(fillColor)
        let progressHeight = CGFloat(percent) * rect.height
        let div = rect.divided(atDistance: progressHeight, from: CGRectEdge.maxYEdge)
        context.fill(div.slice)
    }

}
