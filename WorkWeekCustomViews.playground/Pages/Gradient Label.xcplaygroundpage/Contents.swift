//: [Previous](@previous)

import UIKit

class GradientLabel: UILabel {

//    var colors: (start: UIColor, end: UIColor)

}

import PlaygroundSupport

let label = GradientLabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
label.text = "5:38"
label.font = UIFont.systemFont(ofSize: 58)
label.backgroundColor = UIColor(white: 0.2, alpha: 1.0)


let start = UIColor.blue
let end = UIColor.green

let labelSize = label.intrinsicContentSize
UIGraphicsBeginImageContext(labelSize)
let context = UIGraphicsGetCurrentContext()!

let colorSpace = CGColorSpaceCreateDeviceRGB()
let colors: NSArray = [start.cgColor, end.cgColor]
guard let gradient = CGGradient(colorsSpace: colorSpace,
                                colors: colors,
                                locations: [0, 1]) else { fatalError() }
let startPoint = CGPoint(x: labelSize.width / 2, y: 0)
let endPoint = CGPoint(x: labelSize.width / 2, y: labelSize.height)

context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

let bgimage = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

if let bgImage = bgimage {
    let gradientColor = UIColor(patternImage: bgImage)
    label.textColor = gradientColor
} else {
    label.textColor = .black
}

label.font = UIFont.systemFont(ofSize: 58)
label.backgroundColor = UIColor(white: 0.2, alpha: 1.0)

PlaygroundPage.current.liveView = label


//: [Next](@next)
