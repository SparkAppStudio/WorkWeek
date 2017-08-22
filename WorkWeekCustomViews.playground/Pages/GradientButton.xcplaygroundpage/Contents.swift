//: [Previous](@previous)

import PlaygroundSupport
import UIKit

public class GradientButton: UIButton {
    private var start = UIColor.red
    private var end = UIColor.blue

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: NSArray = [start.cgColor, end.cgColor]
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors,
                                        locations: [0, 1]) else { return }
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: rect.size.width, y: 0)

        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
}

let responder = Responder()

let button = GradientButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
button.addTarget(responder, action: #selector(Responder.buttonTapped(_:)), for: .touchUpInside)

PlaygroundPage.current.liveView = button

//: [Next](@next)
