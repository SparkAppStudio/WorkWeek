//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

@IBDesignable
class TwoLabelButton: UIButton {

    var rightTitle: String {
        get { return right.text ?? "" }
        set {
            right.text = newValue
            setNeedsLayout()
        }
    }

    var leftTitle: String {
        get { return left.text ?? "" }
        set {
            left.text = newValue
            setNeedsLayout()
        }
    }

    private let right: UILabel = {
        let r = UILabel(frame: .zero)
        r.textAlignment = .center
        return r
    }()

    private let left: UILabel = {
        let l = UILabel(frame: .zero)
        l.textAlignment = .left
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private var stack: UIStackView!

    private func sharedInit() {
        self.setTitle(nil, for: .normal)
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false
        self.stack = stack
        stack.alignment = .center
        stack.distribution = .fillProportionally
        self.addSubview(stack)

        right.text = "8.0"
        left.text = "Target Hours Per Day"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
