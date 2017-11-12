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
    var percentOfWorkRemaining: Double { get }
    var timeLeftInWeek: TimeInterval { get }
}

final class CountdownViewController: UIViewController {

    // MARK: Variables
    private var countdownTVCIdentifier = "CountdownTVC"

    // MARK: IBOutlets
    @IBOutlet weak var countdownView: CountdownRingView!
    @IBOutlet weak var countdownTimeLabel: UILabel!
    @IBOutlet weak var weekCountdownTimeLabel: UILabel!
    @IBOutlet weak var tableView: TransparentHeaderTableView!


    // MARK: IBActions
    @IBAction func didTapSettings(_ sender: UIButton) {
        delegate?.countdownPageDidTapSettings()
    }

    weak var delegate: CountdownViewDelegate?
    var headerData: CountdownData!
    var tableViewData: (UITableViewDataSource & UITableViewDelegate)!

    var timer = Timer()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableViewData
        tableView.delegate = tableViewData
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        registerNib()

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
        countdownTimeLabel.text = hourMinuteFormatter.string(from: headerData.timeLeftInDay)
        let weekHours = hoursFormatter.string(from: headerData.timeLeftInWeek)!
        weekCountdownTimeLabel.text = "\(weekHours) work hours left in the week"
        countdownView.endPercentage = CGFloat(headerData.percentOfWorkRemaining)
    }

    private func registerNib() {
        let nib = UINib(nibName: "CountdownTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: countdownTVCIdentifier)
    }
}

extension CountdownViewController: ActivityStoryboard { }

class CountDownTableViewDSD: NSObject, UITableViewDelegate, UITableViewDataSource {

    // MARK: Variables
    private var countdownTVCIdentifier = "CountdownTVC"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: countdownTVCIdentifier,
                                                 for: indexPath) as! CountdownTVC // swiftlint:disable:this force_cast
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        action(results[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
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

