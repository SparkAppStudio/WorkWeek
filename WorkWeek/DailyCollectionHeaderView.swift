//
//  DailyCollectionHeaderView.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/25/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class DailyCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var currentDateLabel: UILabel!
    func configureView(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        currentDateLabel.text = dateFormatter.string(from: date as Date)
    }
}
