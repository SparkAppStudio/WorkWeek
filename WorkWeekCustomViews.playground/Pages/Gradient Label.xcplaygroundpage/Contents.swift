//: [Previous](@previous)

import UIKit

class GradientLabel: UILabel {

}

import PlaygroundSupport

let label = GradientLabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
label.text = "5:38"
label.textColor = UIColor.white
label.font = UIFont.systemFont(ofSize: 58)
label.backgroundColor = UIColor(white: 0.2, alpha: 1.0)

PlaygroundPage.current.liveView = label


//: [Next](@next)
