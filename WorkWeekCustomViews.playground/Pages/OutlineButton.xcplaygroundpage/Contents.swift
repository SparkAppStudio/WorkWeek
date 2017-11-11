//: [Previous](@previous)

import UIKit

class OutlineButton: UIButton {
    var color: UIColor = .white {
        didSet {
            setNeedsDisplay()
            label.textColor = color
        }
    }
    var title: String {
        set {
            label.text = newValue
        }
        get {
            return label.text ?? ""
        }
    }

    override func draw(_ rect: CGRect) {
        let insetRect = rect.insetBy(dx: 4, dy: 4)
        let outlinePath = UIBezierPath(roundedRect: insetRect, cornerRadius: 12.0)
        color.setStroke()
        outlinePath.lineWidth = 1.0
        outlinePath.stroke()
    }

    lazy private var label: UILabel = {
        let l = UILabel(frame: CGRect.zero)
        l.frame = self.bounds
        l.textColor = self.color
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 24.0)
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        addSubview(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.label.textColor = color.withAlphaComponent(0.6)
        color = color.withAlphaComponent(0.6)
        setNeedsDisplay()
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.label.textColor = color.withAlphaComponent(1.0)
        color = color.withAlphaComponent(1.0)
        setNeedsDisplay()
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.identity
        }
    }
}

import PlaygroundSupport

let responder = Responder()
let backgroundColor = UIColor(red: 0.24, green: 0.51, blue: 0.97, alpha: 1)
let backgroundRect = CGRect(x: 0, y: 0, width: 400, height: 400)
let backgroundView = UIView(frame: backgroundRect)
backgroundView.backgroundColor = backgroundColor

let frame = CGRect(x: 20, y: 20, width: 300, height: 72)
let button = OutlineButton(frame: frame)
button.title = "No Thanks"
button.color = .red
button.addTarget(responder, action: #selector(Responder.buttonTapped(_:)), for: .touchUpInside)
backgroundView.addSubview(button)
PlaygroundPage.current.liveView = backgroundView

//: [Next](@next)
