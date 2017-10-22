//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class TransparentHeaderTableView: UITableView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        if tableHeaderView?.frame.contains(point) ?? false {
            return nil
        } else {
            return self
        }
    }
}
