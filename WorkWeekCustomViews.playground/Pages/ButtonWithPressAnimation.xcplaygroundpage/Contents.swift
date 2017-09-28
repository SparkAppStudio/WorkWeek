//: [Previous](@previous)

//: Playground - noun: a place where people can play

import UIKit

class RoundedLayer: CAShapeLayer {
    override var path: CGPath? { get {
        return UIBezierPath(roundedRect: frame, cornerRadius: 12).cgPath
        }
        set { fatalError("Don't set me bro") }
    }
}

class ActiveButton: UIButton {

    var bgFrame: CGRect {
        return bounds.offsetBy(dx: 0, dy: -1.0)
    }
    var bgHighlightFrame: CGRect {
        return frame
    }
    var bgColor: CGColor {
        return UIColor.orange.cgColor
    }
    var fgColor: CGColor {
        return UIColor.gray.cgColor
    }
    var fgHighlightColor: CGColor {
        return UIColor.lightGray.cgColor
    }

    lazy var backgroundLayer: CAShapeLayer = {
        let bg = RoundedLayer()
        bg.fillColor = self.bgColor
        return bg
    }()
    lazy var foregroundLayer: RoundedLayer = {
        let fg = RoundedLayer()
        fg.fillColor = self.fgColor
        fg.shadowColor = UIColor.black.cgColor
        fg.shadowOffset = CGSize(width: 2, height: 2)
        fg.shadowRadius = 2
        fg.shadowOpacity = 0.3
        return fg
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundLayer.frame = bgFrame
        layer.addSublayer(backgroundLayer)
        foregroundLayer.frame = bounds
        layer.addSublayer(foregroundLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implimented")
    }


    override var isHighlighted: Bool {
        get {
            print("HighLightStateRequested")
            return super.isHighlighted
        }
        set {
            animateBG(highlighted: newValue)
            print("Setting button Highlighted=\(newValue)")
            super.isHighlighted = newValue
        }
    }

    func animateBG(highlighted: Bool) {
        if highlighted {
            foregroundLayer.fillColor = fgHighlightColor
            backgroundLayer.setAffineTransform( CGAffineTransform(translationX: 0, y: 2))
            foregroundLayer.shadowOpacity = 0.0
        } else {
            foregroundLayer.fillColor = fgColor
            backgroundLayer.setAffineTransform(CGAffineTransform.identity)
            foregroundLayer.shadowOpacity = 0.3
        }
    }
}

import PlaygroundSupport

let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
backgroundView.backgroundColor = .white

let button = ActiveButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))

backgroundView.addSubview(button)
button.center = backgroundView.center

PlaygroundPage.current.liveView = backgroundView


//: [Next](@next)
