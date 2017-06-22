//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation

class SettingsCoordinator: SettingsMainProtocol {

    enum MapConfig {
        case home
        case work
    }

    // MARK: Settings Main Protocol

    func didTapHomeMap() {
        <#code#>
    }

    func didTapWorkMap() {
        <#code#>
    }

    func notificationsSwitched(_ isOn: Bool) {
        <#code#>
    }

}

protocol SettingsMainProtocol {
    func didTapWorkMap()
    func didTapHomeMap()
    func notificationsSwitched()
}
