//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

class NoDataCoachViewController: UIViewController {

    let coachHeading: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        coachHeading.text = "Go to the office, we'll let you know when it's time to leave"
        view.addSubview(coachHeading)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        NSLayoutConstraint.activate([
            coachHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            coachHeading.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            coachHeading.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 80)
        ])
    }

}
