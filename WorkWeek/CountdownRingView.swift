//
//  CountdownRingView.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 11/11/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

@IBDesignable class CountdownRingView: UIView {

    let arcWidth: CGFloat = 24.0
    let counterWidth: CGFloat = 24.0

    var endPercentage: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var arcColor: UIColor = UIColor.darkContent()
    @IBInspectable var counterColor: UIColor = UIColor.homeGreen()

    override func draw(_ rect: CGRect) {

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = min(bounds.width, bounds.height) / 2

        let context = UIGraphicsGetCurrentContext()!


        backgroundArcPath(context: context, center: center, radius: radius)
        counterPath(center: center, radius: radius, endPercentage: endPercentage)
    }

    func backgroundArcPath(context: CGContext, center: CGPoint, radius: CGFloat) {
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi

        let path = UIBezierPath(arcCenter: center, radius: radius - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        path.lineWidth = arcWidth

        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 4)

        arcColor.setStroke()
        path.stroke()

        //reset context if someone else uses it for future drawing
        context.setShadow(offset: CGSize.zero, blur: 0, color: nil)
    }

    /// Set the End of the counter
    ///
    /// - Parameters:
    ///   - center: center of the ring
    ///   - radius: radius of the ring
    ///   - endPercentage: where the ring ends in percentage, from 0.0 to 1, with offset so the ring starts at north position.
    func counterPath(center: CGPoint, radius: CGFloat, endPercentage: CGFloat) {

        var cleanEndPercentage: CGFloat = 0.0

        if endPercentage < 0 {
            cleanEndPercentage = 0
        } else {
            cleanEndPercentage = endPercentage
        }

        assert(cleanEndPercentage <= 1)

        let rotationConstant: CGFloat = 0.25

        let startAngle: CGFloat = 3 * .pi / 2

        var end = cleanEndPercentage
        if end == 1 {
            end = 0.9999
        }
        let endAngle: CGFloat = (end - rotationConstant) * 2 * .pi

        let path = UIBezierPath(arcCenter: center,
                                radius: radius - counterWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        path.lineWidth = counterWidth
        path.lineCapStyle = .round
        counterColor.setStroke()
        path.stroke()
    }
}
