//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit
import Reusable

class HourTableSectionView: UITableViewHeaderFooterView, Reusable {
    @IBOutlet weak var hourLabel: UILabel!

    func configure(section: Int) {
        hourLabel.textColor = UIColor.themeText()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let sectionString = "\(section):00"
        let date = formatter.date(from: sectionString)

        formatter.dateFormat = "h a"

        let dateString = formatter.string(from: date!)

        hourLabel.text = dateString
    }
}
