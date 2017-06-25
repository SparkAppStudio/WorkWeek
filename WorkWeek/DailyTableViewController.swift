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

        configureNotificationObservers()

    }

    func leftHomeNotified() {
        print("Left Home Notification Received")
        reloadViewController()
    }

    func arriveWorkNotified() {
        print("Arrive Work Notification received")
        reloadViewController()
    }

    func leftWorkNotified() {
        print("Left Work Notification Received")
        reloadViewController()
    }

    func arriveHomeNotified() {
        print("Arrive Home Notification Received")
        reloadViewController()
    }

    func reloadViewController() {
        self.tableView.reloadData()
    }

    func configureNotificationObservers() {
        notificationCenter.addObserver(self, selector: #selector(leftHomeNotified), name: .leftHome)
        notificationCenter.addObserver(self, selector: #selector(arriveWorkNotified), name: .arriveWork)
        notificationCenter.addObserver(self, selector: #selector(leftWorkNotified), name: .leftWork)
        notificationCenter.addObserver(self, selector: #selector(arriveHomeNotified), name: .arriveHome)
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
