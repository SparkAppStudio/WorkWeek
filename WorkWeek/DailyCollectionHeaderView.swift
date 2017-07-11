//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class DailyCollectionHeaderView: UICollectionReusableView {

    static var formatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeZone = TimeZone.current
        return fmt
    }()

    @IBOutlet weak var currentDateLabel: UILabel!
    func configureView(date: Date) {
        currentDateLabel.text = DailyCollectionHeaderView.formatter.string(from: date)
    }
}
