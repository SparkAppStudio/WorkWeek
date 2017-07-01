//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

class WeeklyCollectionViewController: UICollectionViewController {

    var weeklySummaries = TempWeeklyObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        weeklySummaries = RealmManager.shared.getAllDailyObjects()
    }

}

// DataSource
extension WeeklyCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return weeklySummaries.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(for: indexPath) as WeeklyCollectionViewCell
        cell.configureCell()
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
