//: [Previous](@previous)

import UIKit
import PlaygroundSupport

public class MaskedGradientButton: UIButton {
    private var start = UIColor.red
    private var end = UIColor.green

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: NSArray = [start.cgColor, end.cgColor]
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors,
                                        locations: [0, 1]) else { return }
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: rect.size.width, y: 0)

        let clippingPath = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: UIRectCorner.allCorners,
                                        cornerRadii: CGSize(width: 12, height: 12))
        clippingPath.addClip()

        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
}

let responder = Responder()

let button = MaskedGradientButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
button.addTarget(responder, action:#selector(Responder.buttonTapped(_:)), for: .touchUpInside)

PlaygroundPage.current.liveView = button

//: [Next](@next)
