//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

// NOTE: This must match the padding on the storyboard!
// ex: |-padding-|StackView|-padding-| , where | the outer pipe is the scroll View
private let padding: CGFloat = 8

protocol SettingsMainProtocol: class {
    func didTapWorkMap()
    func didTapHomeMap()
    func didTapDone()
}

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

    var user: User!


    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setMainContentStackViewEqualToPhoneWidth()
        configureStyle(of: work, home)
        configureStyle(of: monday, tuesday, wednesday, thursday, friday, saturday, sunday)

        picker.delegate = pickerDataSource
        picker.dataSource = pickerDataSource
        pickerDataSource.delegate = self

        configureSelectedButtons(with: user.weekdays)

        setPickerDefaultRow()
    }

    func setMainContentStackViewEqualToPhoneWidth() {
        mainStackViewContentWidth.constant = UIScreen.main.bounds.width - padding * 2
    }

    func configureStyle(of buttons: UIButton...) {
        for button in buttons {
            button.configureForDefaultStyle()
        }
    }


    // MARK: Actions

    @IBAction func didTapDay(_ sender: UIButton) {
        //toggle
        sender.isSelected = !sender.isSelected
        saveButtonUpdates()
    }

    @IBAction func homeMapPressed(_ sender: UIButton) {
        delegate?.didTapHomeMap()
    }

    @IBAction func workMapPressed(_ sender: UIButton) {
        delegate?.didTapWorkMap()
    }

    @IBAction func notificationsToggled(_ sender: UISwitch) {
        // TODO: Update User Oject Settings Choice
    }

    @IBAction func didTapDone(_ sender: UIButton) {
        delegate?.didTapDone()
    }

    // MARK: Members (RE-asses this name?...

    func configureSelectedButtons(with days: User.Weekdays) {
        sunday.isSelected = days.contains(.sunday)
        monday.isSelected = days.contains(.monday)
        tuesday.isSelected = days.contains(.tuesday)
        wednesday.isSelected = days.contains(.wednesday)
        thursday.isSelected = days.contains(.thursday)
        friday.isSelected = days.contains(.friday)
        saturday.isSelected = days.contains(.saturday)
    }

    func saveButtonUpdates() {
        var updated = user.weekdays
        if sunday.isSelected {
            updated.insert(.sunday)
        } else {
            updated.remove(.sunday)
        }

        if monday.isSelected {
            updated.insert(.monday)
        } else {
            updated.remove(.monday)
        }

        if tuesday.isSelected {
            updated.insert(.tuesday)
        } else {
            updated.remove(.tuesday)
        }

        if wednesday.isSelected {
            updated.insert(.wednesday)
        } else {
            updated.remove(.wednesday)
        }

        if thursday.isSelected {
            updated.insert(.thursday)
        } else {
            updated.remove(.thursday)
        }

        if friday.isSelected {
            updated.insert(.friday)
        } else {
            updated.remove(.friday)
        }

        if saturday.isSelected {
            updated.insert(.saturday)
        } else {
            updated.remove(.saturday)
        }

        RealmManager.shared.update(user: user, with: updated)

    }

    func setPickerDefaultRow() {
        let default8HourIndex = 15
        let index = pickerDataSource.pickerData.index(of: user.hoursInWorkDay) ?? default8HourIndex
        picker.selectRow(index, inComponent: 0, animated: false)
    }

}

extension SettingsViewController: PickerResponseForwarder {
    func didSelectWork(hours: Double) {
        RealmManager.shared.updateHours(for: user, with: hours)
    }
}

extension UIButton {
    func configureForDefaultStyle() {
        layer.cornerRadius = 10.0
        backgroundColor = .gray
        setTitleColor(.white, for: .normal)
    }
}
