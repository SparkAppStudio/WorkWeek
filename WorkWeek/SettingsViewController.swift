//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

// NOTE: This must match the padding on the storyboard!
// ex: |-padding-|StackView|-padding-| , where | the outer pipe is the scroll View
private let padding: CGFloat = 8

final class SettingsViewController: UIViewController {

    @IBOutlet var mainStackViewContentWidth: NSLayoutConstraint!

    @IBOutlet weak var work: UIButton!
    @IBOutlet weak var home: UIButton!

    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setMainContentStackViewEqualToPhoneWidth()
        configureStyle(of: work, home)
        configureStyle(of: monday, tuesday, wednesday, thursday, friday, saturday, sunday)

        guard let monday = monday else {
            assertionFailure("There should always be a monday")
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: Members (RE-asses this name?...

    func setMainContentStackViewEqualToPhoneWidth() {
        mainStackViewContentWidth.constant = UIScreen.main.bounds.width - padding * 2
    }

    func configureStyle(of buttons: UIButton...) {
        for button in buttons {
            button.configureForDefaultStyle()
        }
    }

}

extension SettingsViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
}

extension UIButton {
    func configureForDefaultStyle() {
        layer.cornerRadius = 10.0
        backgroundColor = .gray
        setTitleColor(.white, for: .normal)
    }
}
