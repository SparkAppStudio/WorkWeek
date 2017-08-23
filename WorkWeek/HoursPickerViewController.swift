//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

protocol HoursPickerDelegate: class {
    func pickerFinished(pickerVC: UIViewController)
}

class HoursPickerViewController: UIViewController, SettingsStoryboard {

    let default8HourIndex = 15

    @IBOutlet var containerView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var zeroHeightConstraint: NSLayoutConstraint!

    let pickerDataSource = WorkDayHoursPickerDataSource()
    @IBOutlet weak var picker: UIPickerView!

    weak var delegate: HoursPickerDelegate?
    var pickerValue: Double = 0.0

    var user: User! // provided by Coordinator

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user != nil, "User should be provided by the Coordinator")

        // prepare to animate up
        bottomConstraint.isActive = false
        zeroHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        zeroHeightConstraint.isActive = true

        picker.delegate = pickerDataSource
        picker.dataSource = pickerDataSource
        pickerDataSource.delegate = self

        setInitialPickerSelection()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.layoutIfNeeded()
        UIView.animate(withDuration: 2.0) {
            self.zeroHeightConstraint.isActive = false
            self.bottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func didTapBackground(_ sender: UITapGestureRecognizer) {
        delegate?.pickerFinished(pickerVC: self)
    }

    @IBAction func didTapSave(_ sender: UIButton) {
        updateUserWithSelectedHours()
        delegate?.pickerFinished(pickerVC: self)
    }

    func updateUserWithSelectedHours() {
        RealmManager.shared.updateHours(for: user, with: pickerValue)
    }

    func setInitialPickerSelection() {
        let index = pickerDataSource.pickerData.index(of: user.hoursInWorkDay) ?? default8HourIndex
        picker.selectRow(index, inComponent: 0, animated: false)
    }
}

extension HoursPickerViewController: PickerResponseForwarder {
    func didSelectWork(hours: Double) {
        pickerValue = hours // store to temp in case user cancels
    }
}