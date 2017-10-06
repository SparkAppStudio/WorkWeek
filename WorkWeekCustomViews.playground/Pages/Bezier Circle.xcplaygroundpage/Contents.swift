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

        backgroundArcPath(center: center, radius: radius)
        let counterEnd: CGFloat = 5 * .pi / 6
        counterPath(center: center, radius: radius, endAngle: counterEnd)
    }

    func backgroundArcPath(center: CGPoint, radius: CGFloat) {
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi

        let path = UIBezierPath(arcCenter: center, radius: radius - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        //shadow not working
        let layer: CAShapeLayer = CAShapeLayer()
        layer.frame = bounds
        layer.path = path.cgPath
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1

        layer.shadowColor = UIColor.blue.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        path.lineWidth = arcWidth
        arcColor.setStroke()
        path.stroke()
    }

    func counterPath(center: CGPoint, radius: CGFloat, endAngle: CGFloat) {
        let startAngle: CGFloat = 3 * .pi / 2

        let path = UIBezierPath(arcCenter: center, radius: radius - counterWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        path.lineWidth = counterWidth
        counterColor.setStroke()
        path.stroke()
        let endPoint = CGPoint(x: path.currentPoint.x - 20, y: path.currentPoint.y - 20)

        let aView = UIView(frame: CGRect(origin: endPoint, size: CGSize(width: 50, height: 50)))
        aView.backgroundColor = UIColor.blue
        aView.makeCircle()
        self.addSubview(aView)
    }

}

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
//: [Next](@next)
