//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControlView: UIView {

    @IBOutlet weak var controller: UISegmentedControl!

    override func draw(_ rect: CGRect) {
        controller.styleSparksegmentedController(tint: UIColor.white)
        drawSparkRect(rect, color: UIColor.darkContent())
    }
}
