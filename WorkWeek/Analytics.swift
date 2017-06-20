//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

/// Where you track your events
///
/// USAGE
/// =====
///    Analytics.track(.pageView(.onboarding("GreenVC)), "Green VC dismissed")
///
///    let moreData = ["user": userID, "customerNumber": customerNumber]
///    Analytics.track(.appEvent("Checkout"), "Purchase", moreData)
///
/// I think that this API is not totally set in stone... When we have a few more
/// events to track we may have a better sense of what is important here.
final class Analytics {

    /// The possible types of events to be tracked
    ///
    /// - pageView: The user viewed a page of our application.
    /// - appEvent: Some other type of App Event
    enum Event {
        case pageView(Page)
        case appEvent(String)
    }

    /// The current 3 page types, for tracking pageView Events
    ///
    /// - onboarding: pass a string to give it some uniquenness
    /// - settings: pass a string to give it some uniquenness
    /// - activity: pass a string to give it some uniquenness
    enum Page {
        case onboarding(String)
        case settings(String)
        case activity(String)
    }

    /// Here's where you track your events
    ///
    /// - Parameters:
    ///   - event: The event type you'd like to track
    ///   - content: An assocaited description, String
    ///   - moreData: Any more data you'd like to record, user email, sale total, etc
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
            switch page {
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
