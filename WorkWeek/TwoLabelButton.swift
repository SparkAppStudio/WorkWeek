//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

@IBDesignable
final class TwoLabelButton: UIButton {

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

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.left, self.right])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        self.setTitle(nil, for: .normal)
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
