//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

@IBDesignable class ThemeButton: UIButton {

    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        setTitleColor(UIColor.themeText(), for: .normal)
        drawSparkRect(rect, color: UIColor.themeContent())
    }
}

@IBDesignable class ThemeView: UIView {
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        drawSparkRect(rect, color: UIColor.themeContent())

    }
}

@IBDesignable class MapThemeView: UIView {
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        drawSparkRect(rect, color: UIColor.themeBackground(), xInset: 0, yInset: 0, cornerRadius: rect.getRoundedCorner(), setShadow: false)
    }
}
