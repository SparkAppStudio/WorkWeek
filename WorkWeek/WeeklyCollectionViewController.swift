//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable
import RealmSwift

class WeeklyCollectionViewController: UICollectionViewController {

    // TODO: - Move these to coordinator
    lazy var realm: Realm? = {
        do {
            var realm = try Realm()
            return realm
        } catch {
            Log.log("error access realm")
            return nil
        }
    }()

//    var results: Results<WeeklyObject>!
    lazy var results: Results<WeeklyObject>? = {
        do {
            let now = Date()
            var results = try Realm().objects(WeeklyObject.self)
            return results
        } catch {
            Log.log("error querying daily object")
            return nil
        }
    }()

    var notificationToken: NotificationToken?

    var weeklyReports = [WeeklyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true

        let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.width

        // added some padding around the edges, kept the same ratio as storyboard
        flowLayout?.itemSize = CGSize(width: width, height: (122.0 / 364.0) * width)

        setupRealm()
    }

    func setupRealm() {
        self.notificationToken = results?.addNotificationBlock({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.collectionView?.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.insertItems(at: insertions.map {IndexPath(item: $0, section: 0)})
                    self.collectionView?.deleteItems(at: deletions.map {IndexPath(item: $0, section: 0)})
                    self.collectionView?.reloadItems(at: modifications.map {IndexPath(item: $0, section: 0)})
                }, completion: nil)
                break
            case .error(let err):
                Log.log("fatel error \(err)")
                break
            }
        })
    }
}

// DataSource
extension WeeklyCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
//        weeklyReports = RealmManager.shared.queryAllObjects(ofType: WeeklyObject.self)
//        return weeklyReports.count
        return results?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(for: indexPath) as WeeklyCollectionViewCell
//        cell.configureCell(for: weeklyReports[indexPath.row])
        if let weeklyObject = results?[indexPath.row] {
            cell.configureCell(for: weeklyObject)
        }
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
                                                  withReuseIdentifier: Identifiers.weeklyCollectionHeaderView.rawValue,
                                                  for: indexPath) as? WeeklyCollectionHeaderView
                else {
                    return UICollectionReusableView()
            }
            return headerView
        default:
            // TODO: log this error condition, and what the kind was.
            assert(false, "unexpected element kind")
            return UICollectionReusableView()
        }
    }

}

extension WeeklyCollectionViewController: ActivityStoryboard {
}
