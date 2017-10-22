//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

#if DEBUG
protocol DebugMenuShowing: class {
    func showDebugMenu()
}
#endif

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
    @IBOutlet weak var tableView: TransparentHeaderTableView!

    // MARK: IBActions
    @IBAction func didTapSettings(_ sender: UIButton) {
        delegate?.countdownPageDidTapSettings()
    }

    weak var delegate: CountdownViewDelegate?
    var headerData: CountdownData!
    var tableViewData: (UITableViewDataSource & UITableViewDelegate)!

    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableViewData
        tableView.delegate = tableViewData
        tableView.estimatedRowHeight = UITableViewAutomaticDimension

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
    weak var debugDelegate: DebugMenuShowing?
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
            return true
    }

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            debugDelegate?.showDebugMenu()
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
        countdownDisplay.text = hourMinuteFormatter.string(from: headerData.timeLeftInDay)
        let weekHours = hoursFormatter.string(from: headerData.timeLeftInWeek)!
        weekTimeDisplay.text = "\(weekHours) work hours left in the week"
        percentLeft.text = "\(headerData.percentOfWorkRemaining) % left"
    }
}

extension CountdownViewController: ActivityStoryboard { }

class CountDownTableViewDSD: NSObject, UITableViewDelegate, UITableViewDataSource {

    var results: [WeeklyObject]
    var action: ((WeeklyObject) -> Void)

    init(with weeklyObjects: [WeeklyObject], action: @escaping ((WeeklyObject) -> Void)) {
        self.results = weeklyObjects.reversed()
        self.action = action
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].weekAndTheYear
        cell.textLabel?.textColor = UIColor.white
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        action(results[indexPath.row])
    }
}

class CountDownTableViewCell: UITableViewCell, Reusable {
    lazy var hoursFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        return formatter
    }()

    @IBOutlet weak var totalHoursLabel: UILabel!

    func configure(with weeklyObject: WeeklyObject) {
        let totalTimeInterval = weeklyObject.totalWorkTime
        guard let formattedString = hoursFormatter.string(from: totalTimeInterval) else {
            assertionFailure("Failed to get hours with given time interval")
            return
        }
        totalHoursLabel.text = formattedString
    }
}

