//: [Previous](@previous)
import UIKit
import PlaygroundSupport

struct Colors {
    static let bg = UIColor(red:0.21, green:0.2, blue:0.22, alpha:1)
    static let dark = UIColor.darkGray
    static let green = UIColor(red:0.21, green:0.93, blue:0.84, alpha:1)
    static let blue = UIColor(red:0.24, green:0.51, blue:0.97, alpha:1)
    static let gradL = UIColor(red:0.22, green:0.89, blue:0.51, alpha:1)
    static let gradR = UIColor(red:0.23, green:0.84, blue:0.83, alpha:1)
}

public class BlueButton: UIButton {

    var title: String {
        get { return label.text ?? "" }
        set { label.text = newValue }
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let insetRect = rect.insetBy(dx: 4, dy: 4)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: NSArray = [Colors.gradL.cgColor, Colors.gradR.cgColor]
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

        context.setFillColor(Colors.blue.cgColor)
        let topRect = CGRect(x: insetRect.origin.x, y: insetRect.origin.y + 4, width: insetRect.width, height: insetRect.height - 6)
        let top = UIBezierPath(roundedRect: topRect, cornerRadius: 12)

        context.setShadow(offset: CGSize(width:0, height: 2), blur: 4, color: UIColor.black.cgColor)
        top.fill()
    }

    private let label: UILabel = {
        let l = UILabel(frame: CGRect.zero)
        l.text = "Grant Access"
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 24)
        return l
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        addSubview(label)
        label.sizeToFit()
        let insetRect = frame.insetBy(dx: 4, dy: 4)
        let topRect = CGRect(x: insetRect.origin.x, y: insetRect.origin.y + 4, width: insetRect.width, height: insetRect.height - 6)
        label.frame = topRect
    }
}

class GradientBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    func sharedInit() {
        backgroundColor = .red
        let grad = CAGradientLayer()
        grad.colors = [
            UIColor(red:0.21, green:0.93, blue:0.84, alpha:1).cgColor,
            UIColor(red:0.24, green:0.51, blue:0.97, alpha:1).cgColor]
        grad.locations = [0, 1]
        layer.addSublayer(grad)
        grad.bounds = layer.bounds
        grad.position = layer.position
    }
}

let responder = Responder()

let button = BlueButton(frame: CGRect(x: 0, y: 0, width: 289, height: 76))
button.addTarget(responder, action:#selector(Responder.buttonTapped(_:)) , for: .touchUpInside)
//button.sizeToFit()

let gradientBackground = GradientBackgroundView(frame: UIScreen.main.bounds)

gradientBackground.addSubview(button)
button.center = gradientBackground.center

PlaygroundPage.current.liveView = gradientBackground

//: [Next](@next)
