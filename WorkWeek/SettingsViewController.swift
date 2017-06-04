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

extension SettingsViewController: PickerResponseForwarder {
    func didSelectWork(hours: Double) {
        print("Selected \(hours)")
    }
}

protocol PickerResponseForwarder: class {
    func didSelectWork(hours: Double)
}

class WorkDayHoursPickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    weak var delegate: PickerResponseForwarder?

    let pickerData: [Double] = {
        let str = stride(from: 0.5, to: 24, by: 0.5)
        return Array(str)
    }()

    // This picker is simple, it just show one list of numbers, 0-24 in half hour increments.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // There will only ever be one component so....
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //0.5 for a 30 min work day
        // then each half hour till 23.5?
        // 1, 1.5, 2, 2.5, 3, 3.5,....23, 23.5 = 23*2 = 46 plus the initial 30 min one.
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 50, 100, 150, 200,
        let num = pickerData[row]
        return "\(num)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectWork(hours: pickerData[row])
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
