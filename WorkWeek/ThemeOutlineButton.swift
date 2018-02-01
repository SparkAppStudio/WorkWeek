//
// Copyright © 2018 Spark App Studio All rights reserved.
//

import UIKit

@IBDesignable class OnboardingOutlineButton: UIButton {
    var color: UIColor = .white {
        didSet {
            setNeedsDisplay()
            titleLabel?.textColor = color
        }
    }

    override func draw(_ rect: CGRect) {
        let outlinePath = UIBezierPath.getDefaultRoundedRectPath(rect: rect)
        color.setStroke()
        outlinePath.lineWidth = 1.0
        outlinePath.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.titleLabel?.textColor = color.withAlphaComponent(0.6)
        color = color.withAlphaComponent(0.6)
        setNeedsDisplay()
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.titleLabel?.textColor = color.withAlphaComponent(1.0)
        color = color.withAlphaComponent(1.0)
        setNeedsDisplay()
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.identity
        }
    }
}

@IBDesignable class ThemeOutlineButton: UIButton {

    var color: UIColor = UIColor.themeText() {
        didSet {
            setNeedsDisplay()
            titleLabel?.textColor = color
        }
    }
//    var title: String {
//        set {
//            label.text = newValue
//        }
//        get {
//            return label.text ?? ""
//        }
//    }

    override func draw(_ rect: CGRect) {
        let outlinePath = UIBezierPath.getDefaultRoundedRectPath(rect: rect)
        color.setStroke()
        outlinePath.lineWidth = 1.0
        outlinePath.stroke()
    }

//    lazy private var label: UILabel = {
//        let l = UILabel(frame: CGRect.zero)
//        l.frame = self.bounds
//        l.textColor = self.color
//        l.textAlignment = .center
//        l.font = UIFont.systemFont(ofSize: 24.0)
//        return l
//    }()

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        sharedInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        sharedInit()
//    }
//
//    private func sharedInit() {
//        addSubview(label)
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.titleLabel?.textColor = color.withAlphaComponent(0.6)
        color = color.withAlphaComponent(0.6)
        setNeedsDisplay()
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.titleLabel?.textColor = color.withAlphaComponent(1.0)
        color = color.withAlphaComponent(1.0)
        setNeedsDisplay()
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.identity
        }
    }
}
