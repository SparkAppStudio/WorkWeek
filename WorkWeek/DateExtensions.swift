//  Created by YupinHuPro on 6/27/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

extension Date {

    func dailyActivityTitleDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    func dailyActivityEventDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    func primaryKeyBasedOnDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter.string(from: self)
    }

}
