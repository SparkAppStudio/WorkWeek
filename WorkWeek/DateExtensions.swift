//  Created by YupinHuPro on 6/27/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

extension DateFormatter {
    fileprivate static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
}

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
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    func weeklyPrimaryKeyBasedOnDate() -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents(in: .current, from: self)
        guard let week = dateComponents.weekOfYear else { return ""}
        guard let year = dateComponents.year else { return ""}
        return "\(week)" + "\(year)"
    }

}
