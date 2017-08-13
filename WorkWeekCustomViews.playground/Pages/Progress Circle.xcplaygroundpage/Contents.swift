import UIKit
import PlaygroundSupport

class Circle: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    }

    let backgroundCircleColor: CGColor = UIColor(white: 0.2, alpha: 1.0).cgColor
    let forgroundArcColor: CGColor = UIColor(white: 0.8, alpha: 0.5).cgColor
    let backgroundCircleWidth: CGFloat = 20
    let circleShadow = CGSize(width: 5, height: 5)
    let circleShadowBlur: CGFloat = 2
    let circleShadowColor = UIColor.orange.cgColor

    var progress = 50 // ranges from 100 - 0

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return // be sure to log this error
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: [CGFloat] = [1.0, 0.5, 0.4, 1.0,  // Start color
            0.8, 0.8, 0.3, 1.0]
        let locations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: locations, count: locations.count)

        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        context.drawLinearGradient(gradient!, start: topRight, end: bottomLeft, options: .drawsAfterEndLocation)

        let inset = rect.insetBy(dx: 20, dy: 20)

        //draw background circle
        context.addEllipse(in: inset)
        context.setStrokeColor(backgroundCircleColor)
        context.setLineWidth(backgroundCircleWidth)

        context.setShadow(offset: circleShadow, blur: circleShadowBlur, color: circleShadowColor)

        context.strokePath()

        // convert progress to angle 
        // Top is represented by

        context.addArc(center: inset.center, radius: inset.radius,
                       startAngle: 0 - (.pi/2.0), endAngle: .pi / 2.0, clockwise: false)
        context.setStrokeColor(forgroundArcColor)
        context.setLineWidth(backgroundCircleWidth)
        context.strokePath()

    }

}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    var radius: CGFloat {
        return min(midX - minX, midY - minY)
    }
}

let circleFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
let circle = Circle(frame: circleFrame)
PlaygroundPage.current.liveView = circle


//: [Next](@next)
