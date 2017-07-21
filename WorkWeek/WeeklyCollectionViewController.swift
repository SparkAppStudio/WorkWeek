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

// MARK: - DataSource

extension WeeklyCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(for: indexPath) as WeeklyCollectionViewCell
        if let weeklyObject = results?[indexPath.row] {
            cell.configureCell(for: weeklyObject)
        }
        return cell
    }

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
                    Log.log(.error, "Failed to get header for \(Identifiers.weeklyCollectionHeaderView.rawValue)")
                    return UICollectionReusableView()
            }
            return headerView
        default:
            assertionFailure("unexpected element kind")
            Log.log(.error, "Couldn't dequeue Supplementary View for \(kind)")
            return UICollectionReusableView()
        }
    }

}

extension WeeklyCollectionViewController: ActivityStoryboard {
}
