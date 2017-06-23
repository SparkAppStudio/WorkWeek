//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Fabric
import Crashlytics

/// A wrapper class to support our crash reporting system. Starting like this 
/// helps keep out App, not coupled to the systems we are choosing to use.
final class CrashReporting {
    static let shared = CrashReporting()

    /// Used to configure the Crash reporting system.
    /// Add `CrashReporting.configure()` to your AppDelegate
    static func configure() {
        _ = CrashReporting.shared // Access the singleton to create it.
    }

    private init() {
        Fabric.with([Crashlytics.self])
    }
}
