//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let mainBlue = UIColor(red:0.24, green:0.51, blue:0.97, alpha:1)
let mainGreen = UIColor(red:0.21, green:0.93, blue:0.31, alpha:1)

class ButtonWithBGandShadow: UIButton {

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
        let shadowSize = CGSize(width: 5, height: 5)
        ctx.setShadow(offset: shadowSize, blur: 20)

        ctx.setFillColor(mainBlue.cgColor)
        ctx.fillPath()
    }

    func drawBackground(_ ctx: CGContext, _ rect: CGRect) {
        var rect = rect
        rect.origin = CGPoint(x: rect.origin.x, y: rect.origin.y - 4)

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

        ctx.setFillColor(mainGreen.cgColor)
        ctx.fillPath()
    }
}

let responder = Responder()

let button = ButtonWithBGandShadow(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
button.addTarget(responder, action: #selector(Responder.buttonTapped(_:)), for: .touchUpInside)

PlaygroundPage.current.liveView = button

//: [Next](@next)
