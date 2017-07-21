//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case hasSeenOnboarding
        case overrideShowSettingsFirst
    }

    func bool(for key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }

    func set(_ value: Bool, for key: Key) {
        set(value, forKey: key.rawValue)
    }

    //someday John
    //    @available(*, deprecated)
    //    open func set(_ value: Bool, forKey defaultName: String) {
    //        self.set(value, forKey: defaultName)
    //    }
}
