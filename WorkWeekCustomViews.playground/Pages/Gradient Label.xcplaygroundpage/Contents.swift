//: [Previous](@previous)

import UIKit

class GradientLabel: UILabel {
}

func gradientImage(ofSize size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    defer { UIGraphicsEndImageContext() }

    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)

    guard let ctx = UIGraphicsGetCurrentContext() else {
        print("Sorry No context")
        return nil
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colors: NSArray = [UIColor.red.cgColor,
                           UIColor.blue.cgColor]
    guard let gradient = CGGradient(colorsSpace: colorSpace,
                              colors: colors,
                              locations: [0, 1]) else { return nil }
    let startPoint = CGPoint(x: 0, y: 0)
    let endPoint = CGPoint(x: 0, y: rect.size.height)

    ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    return UIGraphicsGetImageFromCurrentImageContext()
}


import PlaygroundSupport

let label = GradientLabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
label.font = UIFont.systemFont(ofSize: 58)
label.text = "5:38"

let size = label.sizeThatFits(CGSize(width: 100, height: 100))
let gradientImg = gradientImage(ofSize: size)!
label.textColor = UIColor(patternImage: gradientImg)



let superView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
superView.backgroundColor = .white
superView.addSubview(label)


PlaygroundPage.current.liveView = superView


//: [Next](@next)
