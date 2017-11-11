//: [Previous](@previous)

import UIKit
import PlaygroundSupport

struct Colors {
    static let background = UIColor(red: 0.21, green: 0.2, blue: 0.22, alpha: 1)
    static let dark = UIColor.darkGray
    static let green = UIColor(red: 0.21, green: 0.93, blue: 0.84, alpha: 1)
    static let blue = UIColor(red: 0.24, green: 0.51, blue: 0.97, alpha: 1)
}

public class SparkButton: UIButton {

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        UIColor.white.setFill()
        UIRectFill(rect)

        let insetRect = rect.insetBy(dx: 4, dy: 4)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: NSArray = [Colors.green.cgColor, Colors.blue.cgColor]
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors,
                                        locations: [0, 1]) else { return }
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: rect.size.width, y: 0)

        context.saveGState()
        let clippingPath = UIBezierPath(roundedRect: insetRect,
                                        cornerRadius: 12)
        clippingPath.addClip()
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.restoreGState()

        context.setFillColor(Colors.dark.cgColor)
        let topRect = CGRect(x: insetRect.origin.x, y: insetRect.origin.y + 4, width: insetRect.width, height: insetRect.height - 6)
        let top = UIBezierPath(roundedRect: topRect, cornerRadius: 12)

        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.cgColor)
        top.fill()
    }

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 20))

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.text = "Done"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("NO storyboard for you")
    }

    public override func layoutSubviews() {
        label.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {

//        |-----------------|
//        |-----------------|
//        |      text       |
//        |-----------------|

        size

        let labelSize = label.sizeThatFits(size)
        let ourChrome = CGSize(width: 42, height: 36)

//        return CGSize(width: labelSize.width + ourChrome.width,
//                      height: labelSize.height + ourChrome.width)
        return CGSize(width: 200, height: 80)
    }
}

let responder = Responder()

let button = SparkButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
button.addTarget(responder, action: #selector(Responder.buttonTapped(_:)), for: .touchUpInside)
button.sizeToFit()

PlaygroundPage.current.liveView = button

//: [Next](@next)
