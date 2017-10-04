//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

protocol CountdownViewDelegate: class {
    func countdownPageDidTapSettings()
}

protocol CountdownData {
    var timeLeftInDay: TimeInterval { get }
    var percentOfWorkRemaining: Int { get }
    var timeLeftInWeek: TimeInterval { get }
}

final class CountdownViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var countdownDisplay: UILabel!
    @IBOutlet weak var percentLeft: UILabel!
    @IBOutlet weak var weekTimeDisplay: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: IBActions
    @IBAction func didTapSettings(_ sender: UIButton) {
        delegate?.countdownPageDidTapSettings()
    }

    weak var delegate: CountdownViewDelegate?
    weak var selectionDelegate: WeeklySelectionDelegate?
    var data: CountdownData!
    var dataSource = CountDownTableViewDSD()

    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = selectionDelegate
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        title = "Count Down"

        runTimer()
        tick(timer)

        #if DEBUG
        // To get shake gesture
        self.becomeFirstResponder()
        #endif
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.activityCountdown))
    }

    #if DEBUG
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
            return true
    }

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.navigationController?.presentDevSettingsAlertController()
        }
    }
    #endif

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10,
                                     target: self,
                                     selector: (#selector(CountdownViewController.tick(_:))),
                                     userInfo: nil, repeats: true)
    }

    lazy var hourMinuteFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    lazy var hoursFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        return formatter
    }()

    @objc func tick(_ timer: Timer) {
        countdownDisplay.text = hourMinuteFormatter.string(from: data.timeLeftInDay)
        let weekHours = hoursFormatter.string(from: data.timeLeftInWeek)!
        weekTimeDisplay.text = "\(weekHours) work hours left in the week"
        percentLeft.text = "\(data.percentOfWorkRemaining) % left"
    }
}

extension CountdownViewController: ActivityStoryboard { }


protocol WeeklySelectionDelegate: class {
    func selectedWeek(_ week: WeeklyObject)
}

class CountDownTableViewDSD: NSObject, UITableViewDelegate, UITableViewDataSource {

    lazy var results: [WeeklyObject] = {
        let returned = RealmManager.shared.queryAllObjects(ofType: WeeklyObject.self)
        return Array(returned.reversed())
    }()

    weak var delegate: WeeklySelectionDelegate?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountDownCell", for: indexPath) as? CountDownTableViewCell else {
            assertionFailure("Should always succeed")
            return UITableViewCell()
        }
        cell.configureCell(results[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedWeek(results[indexPath.row])
    }

}

class CountDownTableViewCell: UITableViewCell {
    lazy var hoursFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        return formatter
    }()

    @IBOutlet weak var totalHoursLabel: UILabel!

    func configureCell(_ weeklyObject: WeeklyObject) {
        let totalTimeInterval = weeklyObject.totalWorkTime
        guard let formattedString = hoursFormatter.string(from: totalTimeInterval) else {
            assertionFailure("Failed to get hours with given time interval")
            return
        }
        totalHoursLabel.text = formattedString
    }
}

