//
//  Created by YupinHuPro on 7/9/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

extension TimeInterval {
    /// Takes an TimeInterval and convert it to date components format
    ///
    /// - Parameter units: Such as [.hour, ,minute, .second]
    /// - Returns: String
    func convert(preserving units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = [.pad]
        let formattedDuration = formatter.string(from: self)
        return formattedDuration
    }

    func convertAndFormat(preserving units: NSCalendar.Unit) -> String {
        let duration = convert(preserving: units) ?? ""
        guard let durationInt = Int(duration) else {
            return ""
        }
        return "\(durationInt) \(durationInt == 1 ? "hour": "hours")"
    }

    func convertAndFormatCompact(preserving units: NSCalendar.Unit) -> String {
        let duration = convert(preserving: units) ?? ""
        guard duration != "0", let durationInt = Int(duration) else {
            return ""
        }
        return "\(durationInt) \(durationInt == 1 ? "hr": "hrs")"
    }
}
