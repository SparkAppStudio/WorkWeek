//
//  Design.swift
//  WorkWeek
//
//  Created by Douglas Hewitt on 8/21/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

extension UIColor {

    static func dailyGraphGreen() -> UIColor {
        return UIColor.init(displayP3Red: 54/255, green: 236/255, blue: 215/255, alpha: 1)
    }

    static func workBlue() -> UIColor {
        return UIColor(displayP3Red: 60/255, green: 130/255, blue: 248/255, alpha: 1)
    }

    static func homeGreen() -> UIColor {
        return UIColor(displayP3Red: 54/255, green: 236/255, blue: 80/255, alpha: 1)
    }

    static func darkBackground() -> UIColor {
        return UIColor(displayP3Red: 54/255, green: 52/255, blue: 57/255, alpha: 1)
    }

    static func darkContent() -> UIColor {
        return UIColor(displayP3Red: 69/255, green: 68/255, blue: 68/255, alpha: 1)
    }

    static func lightBackground() -> UIColor {
        return UIColor(displayP3Red: 231/255, green: 230/255, blue: 232/255, alpha: 1)
    }

    static func lightContent() -> UIColor {
        return UIColor(displayP3Red: 240/255, green: 239/255, blue: 236/255, alpha: 1)
    }

    static func darkGrayText() -> UIColor {
        return UIColor(displayP3Red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    }

    static func themeBackground() -> UIColor {
        if AppCoordinator.isDarkTheme {
            return UIColor.darkBackground()
        } else {
            return UIColor.lightBackground()
        }
    }

    static func themeContent() -> UIColor {
        if AppCoordinator.isDarkTheme {
            return UIColor.darkContent()
        } else {
            return UIColor.lightContent()
        }
    }

    static func themeText() -> UIColor {
        if AppCoordinator.isDarkTheme {
            return UIColor.white
        } else {
            return UIColor.darkGrayText()
        }
    }
}

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }

    func drawSparkRect(_ rect: CGRect, color: UIColor) -> UIBezierPath {
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        // shadow handled by the button layer now
//        context.setSparkShadow()
        let path = UIBezierPath.getDefaultRoundedRectPath(rect: rect)
        path.fill()
        return path
    }

    func getSparkRect(_ rect: CGRect, color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = color.cgColor
        layer.frame = rect
        layer.setSparkShadow()
        layer.path = UIBezierPath.getDefaultRoundedRectPath(rect: rect).cgPath
        return layer
    }

    func drawSparkBackground(_ rect: CGRect, color: UIColor?) {
        guard let color = color else { return }
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        let insets = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: 0)
        let backgroundRect = UIEdgeInsetsInsetRect(rect, insets)
        UIBezierPath.getDefaultRoundedRectPath(rect: backgroundRect).fill()
    }

    func drawSparkGradientBackground(_ rect: CGRect, startColor: UIColor, endColor: UIColor, xInset: CGFloat, yInset: CGFloat, cornerRadius: CGFloat) {

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()!

        let colors: NSArray = [startColor.cgColor, endColor.cgColor]

        let startPoint = CGPoint(x: 0, y: rect.height)
        let endPoint = CGPoint(x: rect.width, y: 0)

        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors,
                                        locations: [0, 1]) else { return }
        context.saveGState()

        let insets = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: 0)
        let backgroundRect = UIEdgeInsetsInsetRect(rect, insets)

        let clippingPath = UIBezierPath(roundedRect: backgroundRect.insetBy(dx: xInset, dy: yInset), cornerRadius: cornerRadius)

        clippingPath.addClip()
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
    }

    func drawSparkGradientBackground(_ rect: CGRect, startColor: UIColor, endColor: UIColor) -> UIBezierPath? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()!

        let colors: NSArray = [startColor.cgColor, endColor.cgColor]

        let startPoint = CGPoint(x: 0, y: rect.height)
        let endPoint = CGPoint(x: rect.width, y: 0)

        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors,
                                        locations: [0, 1]) else { return nil }
        context.saveGState()

        let insets = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: 0)
        let backgroundRect = UIEdgeInsetsInsetRect(rect, insets)

        let clippingPath = UIBezierPath.getDefaultRoundedRectPath(rect: backgroundRect)
        clippingPath.addClip()
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
        return clippingPath
    }

    func getSparkBackground(_ rect: CGRect, color: UIColor?) -> CAShapeLayer? {
        guard let color = color else { return nil }
        let layer = CAShapeLayer()
        layer.fillColor = color.cgColor
        let insets = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: 0)
        let backgroundRect = UIEdgeInsetsInsetRect(rect, insets)
        layer.frame = backgroundRect
        layer.path = UIBezierPath.getDefaultRoundedRectPath(rect: backgroundRect).cgPath
        return layer
    }

    func drawSparkRect(_ rect: CGRect, color: UIColor, xInset: CGFloat, yInset: CGFloat, cornerRadius: CGFloat, setShadow: Bool) {
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        if setShadow {
            context.setSparkShadow()
        }
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: xInset, dy: yInset), cornerRadius: cornerRadius)
        path.fill()
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let attrs: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraph, .font: UIFont.systemFont(ofSize: size, weight: .heavy), .foregroundColor: UIColor.themeText()]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)

        return self
    }

    @discardableResult func normal(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let attrs: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraph, .font: UIFont.systemFont(ofSize: size), .foregroundColor: UIColor.themeText()]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)

        return self
    }
}

extension UISegmentedControl {
    func styleSparksegmentedController(tint: UIColor) {
        tintColor = tint
//        layer.borderWidth = 3
    }
}

extension CALayer {
    func setSparkShadow() {
        shadowColor = UIColor.black.cgColor
        shadowOpacity = CAShapeLayer.sparkShadowOpacity()
        shadowOffset = CGSize(width: 0, height: 4)
        shadowRadius = 4
    }

    static func sparkShadowOpacity() -> Float {
        return 0.3333
    }

}

extension CGContext {
    func setSparkShadow() {
        setShadow(offset: CGSize(width: 0, height: 4), blur: 4)
    }

    //reset context if someone else uses it for future drawing
    func clearShadow() {
        setShadow(offset: CGSize.zero, blur: 0, color: nil)
    }
}

extension CGRect {
    func getRoundedCorner() -> CGFloat {
        let smaller = min(self.width, self.height)
        return smaller/8
    }
}

extension UIBezierPath {
    static func getDefaultRoundedRectPath(rect: CGRect) -> UIBezierPath {

        return UIBezierPath(roundedRect: rect.insetBy(dx: 6, dy: 6), cornerRadius: rect.getRoundedCorner())
    }
}

extension UIViewController {
    func setTheme(isNavBarTransparent: Bool) {
        view.backgroundColor = UIColor.themeBackground()
        navigationController?.setThemeNavBar(isNavBarTransparent)
    }
}

extension AppCoordinator {

    static var isDarkTheme: Bool {
        get {
            return UserDefaults.standard.bool(for: .darkTheme)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, for: .darkTheme)
            UIApplication.shared.delegate?.window??.setNeedsDisplay()
            for window in UIApplication.shared.windows {
                window.setNeedsDisplay()
            }


        }
    }

    static func getThemeStatusBarStyle() -> UIStatusBarStyle {
        if AppCoordinator.isDarkTheme {
            return UIStatusBarStyle.lightContent
        } else {
            return UIStatusBarStyle.default
        }
    }

    static func switchThemes() {
        AppCoordinator.isDarkTheme = !AppCoordinator.isDarkTheme
        UIApplication.shared.statusBarStyle = getThemeStatusBarStyle()
    }
}

extension UINavigationController {
    func setThemeNavBar(_ isTransparent: Bool) {
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.themeText()]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.tintColor = UIColor.themeText()
        if isTransparent {
            setTransparentNavBar()
        } else {
            setOpaqueNavBar()
        }
    }

    func setOpaqueNavBar() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.themeBackground()
        navigationBar.shadowImage = UIImage()
    }

    func setTransparentNavBar() {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}

extension UIBlurEffectStyle {
    static func themed() -> UIBlurEffectStyle {
        if AppCoordinator.isDarkTheme {
            return .dark
        } else {
            return .light
        }
    }
}

extension UIImage {
    static func getLeftThemeChevron() -> UIImage {
        if AppCoordinator.isDarkTheme {
            return #imageLiteral(resourceName: "left-thin-chevron")
        } else {
            return #imageLiteral(resourceName: "left-thin-chevron dark")
        }
    }

    static func getRightThemeChevron() -> UIImage {
        if AppCoordinator.isDarkTheme {
            return #imageLiteral(resourceName: "right-thin-chevron")
        } else {
            return #imageLiteral(resourceName: "right-thin-chevron dark")
        }
    }
}
