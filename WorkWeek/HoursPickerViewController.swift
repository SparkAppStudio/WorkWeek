//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

protocol HoursPickerDelegate: class {
    func pickerFinished(pickerVC: UIViewController)
}

class HoursPickerViewController: UIViewController, SettingsStoryboard {

    @IBOutlet var containerView: ThemeView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var zeroHeightConstraint: NSLayoutConstraint!

    let pickerDataSource = WorkDayHoursPickerDataSource()
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!

    /// Who to call when we've finished our work.
    weak var delegate: HoursPickerDelegate?

    /// A temp holder for the picker value as it's changed. This value is saved if
    /// the user chooses, or it may be discarded.
    var pickerValue: Double = 0.0

    var user: User! // provided by Coordinator

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user != nil, "User should be provided by the Coordinator")
        prepareContainerForAnimation()
        configurePicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePickerOnScreen()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animatePickerOffScreen()
    }

    func prepareContainerForAnimation() {
        bottomConstraint.isActive = false
        zeroHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        zeroHeightConstraint.isActive = true
    }

    func configurePicker() {
        picker.delegate = pickerDataSource
        picker.dataSource = pickerDataSource
        pickerDataSource.delegate = self
        setInitialPickerSelection()
        styleView()
    }

    func styleView() {
        let blurEffect = UIBlurEffect(style: .themed())
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.insertSubview(blurView, belowSubview: containerView)
        saveButton.setTitleColor(UIColor.themeText(), for: .normal)

    }

    func animatePickerOnScreen() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.zeroHeightConstraint.isActive = false
            self.bottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func animatePickerOffScreen() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.bottomConstraint.isActive = false
            self.zeroHeightConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction func didTapBackground(_ sender: UITapGestureRecognizer) {
        delegate?.pickerFinished(pickerVC: self)
    }

    @IBAction func didTapSave(_ sender: UIButton) {
        updateUserWithSelectedHours()
        delegate?.pickerFinished(pickerVC: self)
    }

    func updateUserWithSelectedHours() {
        DataStore.shared.updateHours(for: user, with: pickerValue)
    }

    func setInitialPickerSelection() {
        let index = pickerDataSource.pickerData.index(of: user.hoursInWorkDay) ??
                        WorkDayHoursPickerDataSource.default8HourIndex
        pickerValue = user.hoursInWorkDay
        picker.selectRow(index, inComponent: 0, animated: false)
    }
}

extension HoursPickerViewController: PickerResponseForwarder {
    func didSelectWork(hours: Double) {
        pickerValue = hours // store to temp in case user cancels
    }
}
