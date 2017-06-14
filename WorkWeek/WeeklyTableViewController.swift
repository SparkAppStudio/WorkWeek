//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

class WeeklyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension WeeklyTableViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Activity", bundle: nil)
}
