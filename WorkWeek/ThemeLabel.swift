//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

@IBDesignable class ThemeLabel: UILabel {
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        textColor = UIColor.themeText()
        _ = drawSparkRect(rect, color: UIColor.themeContent())
        drawText(in: rect.insetBy(dx: 12, dy: 12))
    }
}
