//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

final class Analytics {
    enum Event {
        case pageView(Page)
        case appEvent(String)
    }

    enum Page {
        case onboarding(String)
        case settings(String)
        case activity(String)
    }

    static func track(_ event: Event,
                      _ content: String,
                      moreData: [String: Any]? = nil) {

        var theData: [String: Any] = ["Content": content]
        if let moreData = moreData {
            theData.merge(moreData)
        }
        let eventName: String
        switch event {
        case .appEvent(let theEvent):
            eventName = theEvent
        case .pageView(let page):
            switch  page {
            case .onboarding(let info):
                eventName = "Onboarding: \(info)"
            case .settings(let info):
                eventName = "Settings: \(info)"
            case .activity(let info):
                eventName = "Activity: \(info)"
            }
        }
        Answers.logCustomEvent(withName: eventName, customAttributes: theData)
    }
}
