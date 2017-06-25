//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

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

        configureNotificationObservers()

    }

    func leftHomeNotified() {
        print("Left Home Notification Received")
    }

    func arriveWorkNotified() {
        print("Arrive Work Notification received")
    }

    func leftWorkNotified() {
        print("Left Work Notification Received")
    }

    func arriveHomeNotified() {
        print("Arrive Home Notification Received")
    }

    func configureNotificationObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(leftHomeNotified),
                                       name: NSNotification.Name(rawValue: NotificationCenter.Notes.leftHome.rawValue),
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(arriveWorkNotified),
                                       name: NSNotification.Name(rawValue:NotificationCenter.Notes.arriveWork.rawValue),
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(leftWorkNotified),
                                       name: NSNotification.Name(rawValue:NotificationCenter.Notes.leftWork.rawValue),
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(arriveHomeNotified),
                                       name: NSNotification.Name(rawValue:NotificationCenter.Notes.arriveHome.rawValue),
                                       object: nil)
    }

}

// MARK: - DataSource
extension DailyTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmManager.shared.getTodayObject().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell")
            else {return UITableViewCell()}
        cell.textLabel?.text = RealmManager.shared.getTodayObject()[indexPath.row].activityTime?.description
        return cell
    }
}

extension DailyTableViewController: ActivityStoryboard {
}
