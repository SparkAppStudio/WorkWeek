//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let aView = CounterView(frame: CGRect(x: 0, y: 0, width: 230, height: 230))

PlaygroundPage.current.liveView = aView


@IBDesignable class CounterView: UIView {
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76

        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }

    @IBInspectable var counter: Int = 5
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange

    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height)

        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4

        let path = UIBezierPath(arcCenter: center, radius: radius/2 - Constants.arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
    }
}
//: [Next](@next)
