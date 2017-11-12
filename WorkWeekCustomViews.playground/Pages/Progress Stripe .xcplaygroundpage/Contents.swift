import UIKit
import PlaygroundSupport

class ProgressStripe: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.white
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let fillColor = UIColor.purple.cgColor
        context.setFillColor(fillColor)
        let div = rect.divided(atDistance: 100, from: CGRectEdge.maxYEdge)
        context.fill(div.slice)
    }

}

let stripeFrame = CGRect(x: 0, y: 0, width: 30, height: 500)
let circle = ProgressStripe(frame: stripeFrame)
PlaygroundPage.current.liveView = circle


//: [Next](@next)

