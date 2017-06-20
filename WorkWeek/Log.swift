//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import Crashlytics

final class Log {

    enum Level: String {
        case debug
        case error
    }

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    static private func log(_ level: Level = .debug,
                            _ message: String,
                            _ file: String = #file,
                            _ function: String = #function,
                            _ line: Int = #line) {

        var output: String = ""

        output += "[\(level.rawValue)] "
        output += "(\(function), \((file as NSString).lastPathComponent):\(line)) "
        output += ": "

        output += message

        #if DEBUG // The docs say use the other one in production.
            CLSNSLogv("%@", getVaList([output]))
        #else
            CLSLogv("%@", getVaList([output]))
        #endif
    }
}
