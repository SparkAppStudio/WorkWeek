//: [Previous](@previous)

import UIKit

class MyVC: UIViewController {
    @objc func buttonTapped(_ sender: UIButton) {
        print("Button was tapped")
    }
}

class GradientLayer: CALayer {

    var color1: UIColor
    var color2: UIColor

    init(color1: UIColor, color2: UIColor) {
        self.color1 = color1
        self.color2 = color2
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func draw(in ctx: CGContext) {
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fill(self.frame)
    }

    var gradient: CGGradient {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = color1.colorComponents + color2.colorComponents
        var locations: [CGFloat] = [0.0, 0.5]
        let g = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: &locations, count: locations.count)!
        return g
    }

}

let mainBlue = UIColor(red:0.24, green:0.51, blue:0.97, alpha:1)
let mainGreen = UIColor(red:0.21, green:0.93, blue:0.31, alpha:1)

class GradientView: UIView {

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {fatalError()}

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(rect)

        let backgroundRect = rect.insetBy(dx: 20, dy: 20)
        drawBackground(ctx, backgroundRect)

        let foregroundRect = rect.insetBy(dx: 20, dy: 20)
        drawForeground(ctx, foregroundRect)
    }

    func drawForeground(_ ctx: CGContext, _ rect: CGRect) {
        ctx.beginPath()

        let topMiddle = CGPoint(x: rect.midX, y: rect.minY)
        ctx.move(to: topMiddle)

        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)

        ctx.addArc(tangent1End: topRight, tangent2End: bottomRight, radius: 12.0)
        ctx.addArc(tangent1End: bottomRight, tangent2End: bottomLeft, radius: 12.0)
        ctx.addArc(tangent1End: bottomLeft, tangent2End: topLeft, radius: 12.0)
        ctx.addArc(tangent1End: topLeft, tangent2End: topRight, radius: 12.0)

        ctx.closePath()

        ctx.setLineWidth(5)
        let shadowSize = CGSize(width: 10, height: 10)
        ctx.setShadow(offset: shadowSize, blur: 20)


        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.setFillColor(mainBlue.cgColor)
        ctx.fillPath()
        ctx.strokePath()
    }

    func drawBackground(_ ctx: CGContext, _ rect: CGRect) {
        var rect = rect
        rect.origin = CGPoint(x: rect.origin.x, y: rect.origin.y - 2)

        let topMiddle = CGPoint(x: rect.midX, y: rect.minY)
        ctx.move(to: topMiddle)

        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)

        ctx.addArc(tangent1End: topRight, tangent2End: bottomRight, radius: 12.0)
        ctx.addArc(tangent1End: bottomRight, tangent2End: bottomLeft, radius: 12.0)
        ctx.addArc(tangent1End: bottomLeft, tangent2End: topLeft, radius: 12.0)
        ctx.addArc(tangent1End: topLeft, tangent2End: topRight, radius: 12.0)

        ctx.closePath()

        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillPath()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


import PlaygroundSupport

//let button = Button(frame: CGRect(x: 0, y: 0, width: 288, height: 75))
//
//button.target(forAction: #selector(MyVC.buttonTapped(_:)), withSender: nil)

PlaygroundPage.current.liveView = GradientView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

//: [Next](@next)
