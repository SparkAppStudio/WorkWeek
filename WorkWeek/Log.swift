//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import Crashlytics

/// A Logging class to let us simply, log things to the console, and allow them
/// to be viewed along side crash reports.
///
/// USAGE
/// -----
///     Log.log("My Message Here")
///     Log.log(.error, "There was an error here)
///
/// NOTE: If we change from Crashlytics, we may need to change this as well.
final class Log {

    /// An enum allowing us to define multiple levels of logging.
    /// currently all logs are sent to the server, but we may want to introduce
    /// an info level that is simply printed to the console and ignored in
    /// release builds
    ///
    /// - debug: A message used for debugging
    /// - error: A message indicating that some error condition was hit
    enum Level: String {
        case debug
        case error
    }

    /// Logs you message with the default logging level
    ///
    /// Note: You probably don't want to input anything for the `file`,
    ///       `function`, and `line` parameters. These will be filled in by the
    ///       Swift compiler automatically, to track where the comment originated
    ///
    /// - Parameters:
    ///   - message: The Message string to be logged
    static func log(_ message: String = "-",
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
        log(.debug, message, file, function, line)
    }

    /// A more detailed log function to give you control over which level your
    /// message is logged at. Use `log(_:)` to use the default level.
    ///
    /// - Parameters:
    ///   - level: The importance of your message
    ///   - message: What you want to say
    static func log(_ level: Level,
                    _ message: String = "-",
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {

        var output: String = ""

        output += "[\(level.rawValue)] "
        output += "(\(function), \((file as NSString).lastPathComponent):\(line)) "
        output += ": "

        output += message

        #if DEBUG // The Crashlytics docs say don't use `CSSNSLogv` in production.
            CLSNSLogv("%@", getVaList([output]))
        #else
            CLSLogv("%@", getVaList([output]))
        #endif
    }

    // MARK: - Private

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

}
