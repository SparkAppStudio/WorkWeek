//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

extension NotificationCenter {
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NotificationCenter.Notes,
                     object anObject: Any? = nil) {

        self.addObserver(observer,
                    selector: aSelector,
                    name: NSNotification.Name(rawValue: aName.rawValue),
                    object: anObject)
    }

}

class DailyTableViewController: UITableViewController {

    let notificationCenter = NotificationCenter.default


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

        notificationCenter.addObserver(self, selector: #selector(leftHomeNotified), name: .leftHome)


        notificationCenter.addObserver(self,
                                       selector: #selector(arriveWorkNotified),
                                       name: NSNotification.Name(rawValue:NotificationCenter.Notes.arriveWork.rawValue),
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(leftWorkNotified),
                                       name: NSNotification.Name(rawValue:NotificationCenter.Notes.arriveWork.rawValue),
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(arriveHomeNotified),
                                       name: NSNotification.Name(rawValue:NotificationCenter.Notes.arriveWork.rawValue),
                                       object: nil)


    }

    func leftHomeNotified() {
        print("Left Home Notification Received")
    }

    func arriveWorkNotified() {
        print("Arrive Work Notification received")
    }

    func leftWorkNotified() {
        print("Left Home Notification Received")
    }

    func arriveHomeNotified() {
        print("Arrive Home Notification Received")
    }

}

extension DailyTableViewController: ActivityStoryboard {
}
