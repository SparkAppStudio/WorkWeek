//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable


// MARK: Onboarding

protocol OnboardingStoryboard: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard { get }
}

extension OnboardingStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }

    static var storyboardName: String {
        return "Onboarding"
    }

//    private static var storyboardName: String {
//        switch Self.self {
//        case OnboardViewController.self:
//            return "Onboarding"
//        default:
//            assertionFailure("wrong storyboard bro")
//        }
//    }
}

// MARK: Activity

protocol ActivityStoryboard: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard { get }
}

extension ActivityStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }

    static var storyboardName: String {
        return "Activity"
    }
}


// MARK: Settings

protocol SettingsStoryboard: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard { get }
}

extension SettingsStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }

    static var storyboardName: String {
        return "Settings"
    }
}
