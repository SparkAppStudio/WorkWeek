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

class DailyCollectionViewController: UICollectionViewController {

    let notificationCenter = NotificationCenter.default

    var dailyActivityData = [Activity]()

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
        self.collectionView?.reloadData()
    }

    func configureNotificationObservers() {
        notificationCenter.addObserver(self, selector: #selector(leftHomeNotified), name: .leftHome)
        notificationCenter.addObserver(self, selector: #selector(arriveWorkNotified), name: .arriveWork)
        notificationCenter.addObserver(self, selector: #selector(leftWorkNotified), name: .leftWork)
        notificationCenter.addObserver(self, selector: #selector(arriveHomeNotified), name: .arriveHome)
    }

}

// MARK: - DataSource
extension DailyCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dailyActivityData = RealmManager.shared.getTodayObject()
        return dailyActivityData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCollectionViewCell",
                                                            for: indexPath)
                                                            as? DailyCollectionViewCell
            else {
            return UICollectionViewCell()
        }
        cell.configureCell(dailyActivityData[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView
                            .dequeueReusableSupplementaryView(ofKind: kind,
                                                              withReuseIdentifier: "DailyCollectionHeaderView",
                                                              for: indexPath) as? DailyCollectionHeaderView
                else {
                    return UICollectionReusableView()
            }
            headerView.configureCell(date: NSDate())
            return headerView
        default:
            assert(false, "unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

extension DailyCollectionViewController: ActivityStoryboard {
}
