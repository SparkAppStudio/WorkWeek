//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

@IBDesignable class ThemeGradientButton: ThemeButton {
    override func draw(_ rect: CGRect) {
        _ = drawSparkGradientBackground(rect, startColor: UIColor.homeGreen(), endColor: UIColor.workBlue())
        super.draw(rect)
    }
}

@IBDesignable class ThemeHomeButton: ThemeButton {
    override func draw(_ rect: CGRect) {
        drawSparkBackground(rect, color: UIColor.homeGreen())
        super.draw(rect)
    }
}

@IBDesignable class ThemeWorkButton: ThemeButton {
    var borderColor: UIColor = UIColor.workBlue()
    override func draw(_ rect: CGRect) {
        drawSparkBackground(rect, color: borderColor)
        super.draw(rect)
    }
}

@IBDesignable class OnboardingGradientButton: ThemeButton {
    override var textColor: UIColor {
        get {
            return .white
        }
    }
    override var contentColor: UIColor {
        get {
            return .workBlue()
        }
    }

    var backgroundPath: UIBezierPath!

    var shouldClearBackground: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        if shouldClearBackground == false {
            backgroundPath = drawSparkGradientBackground(rect, startColor: UIColor.homeGreen(), endColor: UIColor.dailyGraphGreen())
            super.draw(rect)
        } else {
            backgroundPath = nil
            contentPath = nil
        }
    }
}

@IBDesignable class ThemeButton: UIButton {

    var textColor: UIColor {
        get {
            return UIColor.themeText()
        }
    }
    var contentColor: UIColor {
        get {
            return UIColor.themeContent()
        }
    }

    var contentPath: UIBezierPath!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLayers()
    }

    private func configureLayers() {
        backgroundColor = UIColor.clear
        setTitleColor(textColor, for: .normal)
    }

    override func draw(_ rect: CGRect) {
        layer.setSparkShadow()
        contentPath = drawSparkRect(rect, color: contentColor)
    }

    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            animateButtonPress(highlighted: newValue)
            print("Setting button Highlighted=\(newValue)")
            super.isHighlighted = newValue
        }
    }

    func animateButtonPress(highlighted: Bool) {
        if highlighted {
            // doesnt work
//            let animation = CABasicAnimation(keyPath: "shadow")
//            animation.fromValue = CAShapeLayer.sparkShadowOpacity()
//            animation.toValue = 0.0
//            animation.duration = 1.0
//            layer.add(animation, forKey: animation.keyPath)
            layer.shadowOpacity = 0.0
        } else {
            layer.shadowOpacity = CAShapeLayer.sparkShadowOpacity()
        }
    }
}


//causes problem overlapping other items in button
@IBDesignable class LayerButton: UIButton {

    var sparkBorderColor: UIColor = UIColor.workBlue()
    var backgroundLayer: CAShapeLayer!
    var contentLayer: CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLayers()
    }

    private func configureLayers() {
        backgroundColor = UIColor.clear
        setTitleColor(UIColor.themeText(), for: .normal)

        contentLayer = getSparkRect(bounds, color: UIColor.themeContent())
        layer.addSublayer(contentLayer)
        backgroundLayer = getSparkBackground(bounds, color: sparkBorderColor)
        layer.insertSublayer(backgroundLayer, below: contentLayer)
    }

    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            animateButtonPress(highlighted: newValue)
            print("Setting button Highlighted=\(newValue)")
            super.isHighlighted = newValue
        }
    }

    func animateButtonPress(highlighted: Bool) {
        if highlighted {
            backgroundLayer?.setAffineTransform( CGAffineTransform(translationX: 0, y: 4))
            contentLayer.shadowOpacity = 0.0
        } else {
            backgroundLayer?.setAffineTransform(CGAffineTransform.identity)
            contentLayer.shadowOpacity = CAShapeLayer.sparkShadowOpacity()
        }
    }
}

@IBDesignable class ThemeView: UIView {
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        _ = drawSparkRect(rect, color: UIColor.themeContent())

    }
}

@IBDesignable class ThemeWorkView: ThemeView {
    var borderColor: UIColor = UIColor.workBlue()

    override func draw(_ rect: CGRect) {
        drawSparkBackground(rect, color: borderColor)
        super.draw(rect)
    }
}

@IBDesignable class ThemeGradientView: ThemeView {
    override func draw(_ rect: CGRect) {
        _ = drawSparkGradientBackground(rect, startColor: UIColor.homeGreen(), endColor: UIColor.workBlue())
        super.draw(rect)
    }
}

@IBDesignable class MapThemeView: UIView {
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        drawSparkRect(rect, color: UIColor.themeBackground(), xInset: 0, yInset: 0, cornerRadius: rect.getRoundedCorner(), setShadow: false)
    }
}
