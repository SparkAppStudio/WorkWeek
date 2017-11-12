//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIView {


    @IBOutlet weak var controller: UISegmentedControl!

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        layer.cornerRadius = 12

    }

    override func draw(_ rect: CGRect) {
        styleSegmentedController(controller: controller)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.darkContent().cgColor)
        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 4)

        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 6, dy: 6), cornerRadius: 12)
        path.fill()
    }

    func styleSegmentedController(controller: UISegmentedControl) {
        controller.backgroundColor = UIColor.darkContent()
        controller.tintColor = UIColor.workBlue()
    }

}
