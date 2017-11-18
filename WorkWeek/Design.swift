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
        return UIColor.init(displayP3Red: 54/255, green: 236/255, blue: 215, alpha: 1)
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
        return UIColor.darkBackground()
    }

    static func themeContent() -> UIColor {
        return UIColor.darkContent()
    }

    static func themeText() -> UIColor {
        return UIColor.white
    }
}

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }

    func drawSparkRect(_ rect: CGRect, color: UIColor) {
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.setSparkShadow()
        UIBezierPath.getDefaultRoundedRectPath(rect: rect).fill()
    }

    func drawSparkRect(_ rect: CGRect, color: UIColor, xInset: CGFloat, yInset: CGFloat, cornerRadius: CGFloat) {
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.setSparkShadow()
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: xInset, dy: yInset), cornerRadius: cornerRadius)
        path.fill()
    }
}

extension UISegmentedControl {
    func styleSparksegmentedController(tint: UIColor) {
        tintColor = tint
//        layer.borderWidth = 3
    }
}

extension CGContext {
    func setSparkShadow() {
        setShadow(offset: CGSize(width: 0, height: 2), blur: 4)
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
    func setTheme() {
        view.backgroundColor = UIColor.themeBackground()
        navigationController?.setThemeNavBar()
    }
}

extension UINavigationController {
    func setThemeNavBar() {
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.themeText()]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.tintColor = UIColor.themeText()
        setTransparentNavBar()
    }

    func setTransparentNavBar() {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}
