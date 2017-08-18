//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

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
