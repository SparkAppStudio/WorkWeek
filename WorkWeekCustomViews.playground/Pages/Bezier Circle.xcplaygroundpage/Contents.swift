//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let aView = CounterView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

PlaygroundPage.current.liveView = aView


@IBDesignable class CounterView: UIView {

    let arcWidth: CGFloat = 24.0
    let counterWidth: CGFloat = 24.0
    
    @IBInspectable var arcColor: UIColor = UIColor.lightGray
    @IBInspectable var counterColor: UIColor = UIColor.blue

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.darkGray
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    }

    override func draw(_ rect: CGRect) {

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height) / 2

        let context = UIGraphicsGetCurrentContext()!


        backgroundArcPath(context: context, center: center, radius: radius)
        counterPath(center: center, radius: radius, endPercentage: 0.5)
    }

    func backgroundArcPath(context: CGContext, center: CGPoint, radius: CGFloat) {
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi

        let path = UIBezierPath(arcCenter: center, radius: radius - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        path.lineWidth = arcWidth

        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 4)

        arcColor.setStroke()
        path.stroke()

        context.setShadow(offset: CGSize.zero, blur: 0, color: nil)
    }

    /// Set the End of the counter
    ///
    /// - Parameters:
    ///   - center: center of the ring
    ///   - radius: radius of the ring
    ///   - endPercentage: where the ring ends in percentage, from 0.0 to 1, with offset so the ring starts at north position.
    func counterPath(center: CGPoint, radius: CGFloat, endPercentage: CGFloat) {
        assert(abs(endPercentage) <= 1)

        let rotationConstant: CGFloat = 0.25

        let startAngle: CGFloat = 3 * .pi / 2

        var end = endPercentage
        if end == 1 {
            end = 0.9999
        }
        let endAngle: CGFloat = (end - rotationConstant) * 2 * .pi



        let path = UIBezierPath(arcCenter: center, radius: radius - counterWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        path.lineWidth = counterWidth
        counterColor.setStroke()
        path.stroke()
        let endPoint = CGPoint(x: path.currentPoint.x - counterWidth/2, y: path.currentPoint.y - counterWidth/2)

        guard endPercentage >= 0.02 else {return} //only add nub when line is long enough

        let nubView = UIView(frame: CGRect(origin: endPoint, size: CGSize(width: counterWidth, height: counterWidth)))
        nubView.backgroundColor = counterColor
        nubView.makeCircle()
        self.addSubview(nubView)
    }

}

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
//: [Next](@next)
