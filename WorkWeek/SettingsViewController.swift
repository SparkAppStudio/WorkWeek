//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

// NOTE: This must match the padding on the storyboard!
// ex: |-padding-|StackView|-padding-| , where | the outer pipe is the scroll View
private let padding: CGFloat = 8

final class SettingsViewController: UIViewController, SettingsStoryboard {

    weak var delegate: SettingsMainProtocol?

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

    @IBOutlet weak var picker: UIPickerView!
    var pickerDataSource = WorkDayHoursPickerDataSource()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setMainContentStackViewEqualToPhoneWidth()
        configureStyle(of: work, home)
        configureStyle(of: monday, tuesday, wednesday, thursday, friday, saturday, sunday)

        picker.delegate = pickerDataSource
        picker.dataSource = pickerDataSource
        pickerDataSource.delegate = self

        setPickerDefaultRow()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }


    // MARK: Actions

    @IBAction func homeMapPressed(_ sender: UIButton) {
        delegate?.didTapHomeMap()
    }

    @IBAction func workMapPressed(_ sender: UIButton) {
        delegate?.didTapWorkMap()
    }

    @IBAction func notificationsToggled(_ sender: UISwitch) {
        delegate?.notificationsSwitched(sender.isOn)
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

    func setPickerDefaultRow() {
        let eightHours = 15
        picker.selectRow(eightHours, inComponent: 0, animated: false)
    }
}

extension SettingsViewController: PickerResponseForwarder {
    func didSelectWork(hours: Double) {
        print("Selected \(hours)")
    }
}

extension UIButton {
    func configureForDefaultStyle() {
        layer.cornerRadius = 10.0
        backgroundColor = .gray
        setTitleColor(.white, for: .normal)
    }
}
