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
///     Analytics.track(.pageView(.onboarding("GreenVC)), "Green VC dismissed")
///
///     let moreData = ["user": userID, "customerNumber": customerNumber]
///     Analytics.track(.appEvent("Checkout"), "Purchase", moreData)
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

    /// The list of pages tracked by analytics
    enum Page: String {
        case onboardWelcome
        case onboardExplain
        case onboardLocation
        case onboardSettings
        case onboardNotify

        case activityCountdown
        case activityDaily
        case activityWeekly

        case settingsMap
        case settingsMain
    }

    /// Here's where you track your events
    ///
    /// - Parameters:
    ///   - event: The event type you'd like to track
    ///   - content: An assocaited description, String
    ///   - moreData: Any more data you'd like to record, user email, sale total, etc
    static func track(_ event: Event,
                      _ content: String? = nil,
                      extraData: [String: Any]? = nil) {

        var data: [String: Any] = ["Content": content ?? "n/a"]
        if let extraData = extraData {
            data.merge(extraData)
        }

        let eventName: String
        switch event {
        case .appEvent(let theEvent):
            eventName = theEvent
        case .pageView(let page):
            eventName = page.rawValue
        }
        Answers.logCustomEvent(withName: eventName, customAttributes: data)
    }
}
