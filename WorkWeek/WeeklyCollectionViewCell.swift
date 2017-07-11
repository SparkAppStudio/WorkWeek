//  Created by YupinHuPro on 7/1/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Reusable

class WeeklyCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weeklyHourLabel: UILabel!

    func configureCell(for weeklyObject: WeeklyObject) {
        let totalWorkTime = weeklyObject.totalWorkTime
        weeklyHourLabel.text = totalWorkTime.convert(preserving: [.hour, .minute, .second])
    }
}
