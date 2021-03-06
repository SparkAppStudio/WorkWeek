//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

// NOTE: This must match the padding on the storyboard!
// ex: |-padding-|StackView|-padding-| , where | the outer pipe is the scroll View
private let padding: CGFloat = 8

protocol SettingsMainProtocol: class {
    func didTapWorkMap(nav: UINavigationController)
    func didTapHomeMap(nav: UINavigationController)
    func didTapSelectHours(nav: UINavigationController)
    func didTapDone()
}

final class SettingsViewController: UIViewController, SettingsStoryboard {

    weak var delegate: SettingsMainProtocol?

    @IBOutlet weak var workDaysLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!

    @IBOutlet weak var darkThemeLabel: UILabel!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var workButton: ThemeWorkButton!
    @IBOutlet weak var homeButton: ThemeHomeButton!
    @IBOutlet weak var doneButton: ThemeGradientButton!

    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!

    @IBOutlet weak var targetHoursButton: TwoLabelButton!
    @IBOutlet weak var notificationsSegment: SegmentedControlView!

    var user: User!
//    var day: DailyObject!

    // MARK: View Lifecycle

    override func viewDidLoad() {
        assert(user != nil, "Error! User object should be provided to the VC by the coordinator")
        super.viewDidLoad()
        title = "Settings"
        setTheme(isNavBarTransparent: true)
        darkThemeSwitch.isOn = AppCoordinator.isDarkTheme
        darkThemeSwitch.onTintColor = UIColor.homeGreen()
        workDaysLabel.textColor = UIColor.themeText()
        notificationsLabel.textColor = UIColor.themeText()
        darkThemeLabel.textColor = UIColor.themeText()

        configureSelectedButtons(with: user.weekdays)
        configureNotificationsSegment(with: user.notificationChoice)

        targetHoursButton.rightTitle = "\(user.hoursInWorkDay)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMapButtons(with: user)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.settingsMain))
    }

    // MARK: Actions

    @IBAction func didTapDay(_ sender: UIButton) {
        //toggle
        sender.isSelected = !sender.isSelected
        saveButtonUpdates()
    }

    @IBAction func didTapWork(_ sender: UIButton) {
        delegate?.didTapWorkMap(nav: navigationController!)
    }

    @IBAction func didTapHome(_ sender: UIButton) {
        delegate?.didTapHomeMap(nav: navigationController!)
    }

    @IBAction func didTapSelectHours(_ sender: TwoLabelButton) {
        delegate?.didTapSelectHours(nav: navigationController!)
    }

    @IBAction func didTapDone(_ sender: UIButton) {
        delegate?.didTapDone()
    }

    @IBAction func darkThemeDidChange(_ sender: UISwitch) {
        AppCoordinator.switchThemes()
    }


    // MARK: Members
    func configureNotificationsSegment(with choice: User.NotificationChoice) {
        notificationsSegment.controller.setSelected(choice)
    }

    func updateUserHours(hours: String) {
        targetHoursButton.rightTitle = hours
    }

    @IBAction func didTapNotifications(_ segment: UISegmentedControl) {
        DataStore.shared.updateNotificationsChoice(for: user, with: segment.choice)
    }

    func configureMapButtons(with user: User) {

        if let workAddress = user.workLocation {
            let formattedTitle = NSMutableAttributedString()
            formattedTitle
                .bold("Work\n", size: 14)
                .normal(workAddress, size: 14)
            workButton.setAttributedTitle(formattedTitle, for: .normal)
        } else {
            let formattedTitle = NSMutableAttributedString()
            formattedTitle
                .bold("Work", size: 14)
            workButton.setAttributedTitle(formattedTitle, for: .normal)
        }
        if let homeAddress = user.homeLocation {
            let formattedTitle = NSMutableAttributedString()
            formattedTitle
                .bold("Home\n", size: 14)
                .normal(homeAddress, size: 14)
            homeButton.setAttributedTitle(formattedTitle, for: .normal)
        } else {
            let formattedTitle = NSMutableAttributedString()
            formattedTitle
                .bold("Home", size: 14)
            homeButton.setAttributedTitle(formattedTitle, for: .normal)
        }
    }

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

        DataStore.shared.update(user: user, with: updated)
    }

}

extension UISegmentedControl {
    func setSelected(_ index: User.NotificationChoice) {
        selectedSegmentIndex = index.rawValue
    }
    var choice: User.NotificationChoice {
        return User.NotificationChoice(rawValue: selectedSegmentIndex) ?? .none
    }
}
