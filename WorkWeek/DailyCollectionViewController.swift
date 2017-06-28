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

    var events = [Event]()

    var dailyObject: DailyObject? {
        didSet {
            events.removeAll()
            if let timeLeftHome = dailyObject?.timeLeftHome {
                events.append(timeLeftHome)
            }
            if let timeArriveWork = dailyObject?.timeArriveWork {
                events.append(timeArriveWork)
            }
            if let timeLeftWork = dailyObject?.timeLeftWork {
                events.append(timeLeftWork)
            }
            if let timeArriveHome = dailyObject?.timeArriveHome {
                events.append(timeArriveHome)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        dailyObject = RealmManager.shared.getDailyObject(for: NSDate())
        return events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Identifiers.DailyCollectionViewCell,
                                for: indexPath)
                as? DailyCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(events[indexPath.row])
            return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: Identifiers.DailyCollectionHeaderView,
                                                  for: indexPath) as? DailyCollectionHeaderView
                else {
                    return UICollectionReusableView()
            }
            headerView.configureView(date: NSDate())
            return headerView
        default:
            assert(false, "unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

extension DailyCollectionViewController: ActivityStoryboard {
}
