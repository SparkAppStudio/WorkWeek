//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

extension NotificationCenter {
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NotificationCenter.CheckInEvent,
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
            guard let dailyObject = dailyObject else {
                events.removeAll()
                return
            }
            events = dailyObject.events
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        configureNotificationObservers()

        let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.width

        // was showing as full bleed on the, small phone, added some padding around the edges, kept the same ratio
        flowLayout?.itemSize = CGSize(width: width, height: (256.0 / 375.0) * width)

        // make it so the bottom cell can scroll to be above the dots...
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30.0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30.0, right: 0)
        // wanted to make the whole scroll view be above the dots... not sure which inset that is...
        // could just put a white or translucent view down there.... but it might be hacky to get it under the page indicator
    }

    func reloadViewController() {
        self.collectionView?.reloadData()
    }

    func configureNotificationObservers() {
        notificationCenter.addObserver(self, selector: #selector(reloadViewController), name: .leaveHome)
        notificationCenter.addObserver(self, selector: #selector(reloadViewController), name: .arriveWork)
        notificationCenter.addObserver(self, selector: #selector(reloadViewController), name: .leaveWork)
        notificationCenter.addObserver(self, selector: #selector(reloadViewController), name: .arriveHome)
    }

}

// MARK: - DataSource
extension DailyCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dailyObject = RealmManager.shared.queryDailyObject(for: Date())
        return events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as DailyCollectionViewCell
            cell.configureCell(events[indexPath.row])
            return cell
    }

    // TODO: Log this error condition.
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: Identifiers.dailyCollectionHeaderView.rawValue,
                                                  for: indexPath) as? DailyCollectionHeaderView
                else {
                    return UICollectionReusableView()
            }
            headerView.configureView(date: Date())
            return headerView
        default:
            // TODO: log this error condition, and what the kind was.
            assert(false, "unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

extension DailyCollectionViewController: ActivityStoryboard {
}
