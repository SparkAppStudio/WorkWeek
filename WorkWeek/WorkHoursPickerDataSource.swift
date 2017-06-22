//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

/// The Delegate type of WorkDayHoursPickerDataSource
/// The object that conforms will be notified when the user has made a selection
/// from the picker.
protocol PickerResponseForwarder: class {
    func didSelectWork(hours: Double)
}

/// This picker is simple, it just show one list of numbers
/// 0-24 in half hour increments. starting with 0.5, and ending at 23.5
class WorkDayHoursPickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    /// The delegate is called when the user has selected a row.
    weak var delegate: PickerResponseForwarder?

    /// The data for the picker
    let pickerData: [Double] = {
        let str = stride(from: 0.5, to: 24, by: 0.5)
        return Array(str)
    }()

    /// Just one List of numbers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /// NOTE: There will only ever be one component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    /// Looks at the data source, and converts the corresponding to a String
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let num = pickerData[row]
        return "\(num)"
    }

    /// Calls up to the PickerResponseForwarder to deliver the event
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectWork(hours: pickerData[row])
    }
}
