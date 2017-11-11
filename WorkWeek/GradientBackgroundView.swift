//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class GradientBackgroundView: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        guard let grad = layer as? CAGradientLayer else { return }
        grad.colors = [
            UIColor(red: 0.21, green: 0.93, blue: 0.84, alpha: 1).cgColor,
            UIColor(red: 0.24, green: 0.51, blue: 0.97, alpha: 1).cgColor]
        grad.locations = [0, 1]
    }
}
