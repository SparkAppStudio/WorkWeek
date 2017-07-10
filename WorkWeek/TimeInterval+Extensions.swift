//
//  Created by YupinHuPro on 7/9/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

extension TimeInterval {
    func convertToString(with format: [NSCalendar.Unit]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        let formattedDuration = formatter.string(from: self)
        return formattedDuration
    }
}
