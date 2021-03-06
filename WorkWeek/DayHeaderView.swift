//
// Copyright © 2018 Spark App Studio All rights reserved.
//

import UIKit
import Reusable

protocol DayHeaderViewDelegate: class {
    func didTapLeft(_ sender: UIButton)
    func didTapRight(_ sender: UIButton)
}

class DayHeaderView: ThemeGradientView, Reusable {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    weak var delegate: DayHeaderViewDelegate!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dayLabel.textColor = UIColor.themeText()
        leftButton.setImage(UIImage.getLeftThemeChevron(), for: .normal)
        rightButton.setImage(UIImage.getRightThemeChevron(), for: .normal)
    }

    @IBAction func didTapLeft(_ sender: UIButton) {
        delegate.didTapLeft(sender)
    }

    @IBAction func didTapRight(_ sender: UIButton) {
        delegate.didTapRight(sender)
    }
}
