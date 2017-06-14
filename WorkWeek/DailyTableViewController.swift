//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

class DailyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DailyTableViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Activity", bundle: nil)
}
