//  Created by YupinHuPro on 6/3/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

class DailyTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let todayString = dateFormatter.string(from: today as Date)
        print(todayString)

        let dailyActivity = DailyActivities()
        dailyActivity.dateString = todayString
        dailyActivity.timeLeftHome = NSDate()
        dailyActivity.timeArriveWork = NSDate()
        dailyActivity.timeLeftWork = NSDate()
        dailyActivity.timeArriveHome = NSDate()

//        RealmManager.shared.removeAllObjects()
//        RealmManager.shared.saveDailyActivities(dailyActivity)
        RealmManager.shared.displayAllDailyActivies()
        RealmManager.shared.updateDailyActivities(dailyActivity)
        RealmManager.shared.displayAllDailyActivies()


    }
}

extension DailyTableViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Activity", bundle: nil)
}
