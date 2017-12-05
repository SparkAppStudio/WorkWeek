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

protocol ActivityViewDelegate: class {
    func activityPageDidTapSettings()
}

protocol CountdownData {
    var timeLeftInDay: TimeInterval { get }
    var percentOfWorkRemaining: Double { get }
    var timeLeftInWeek: TimeInterval { get }
}

final class ActivityViewController: UIViewController {

    // MARK: Variables

    // MARK: IBOutlets

    @IBOutlet var ringTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var countdownView: CountdownRingView!
    @IBOutlet weak var countdownTimeLabel: UILabel!
    @IBOutlet weak var weekCountdownTimeLabel: UILabel!
    @IBOutlet weak var tableView: TransparentHeaderTableView!


    // MARK: IBActions

    @IBAction func didTapSettings(_ sender: UIButton) {
        delegate?.activityPageDidTapSettings()
    }

    weak var delegate: ActivityViewDelegate?
    var headerData: CountdownData!
    var tableViewData: (UITableViewDataSource & UITableViewDelegate)!

    var timer = Timer()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return getThemeStatusBarStyle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableViewData
        tableView.delegate = tableViewData
        tableView.estimatedRowHeight = UITableViewAutomaticDimension

        title = "Count Down"

        runTimer()
        tick(timer)

        registerForApplicationActiveNotifications()

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
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(ActivityViewController.tick(_:))),
                                     userInfo: nil, repeats: true)
    }

    lazy var hourMinuteFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
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
}

extension ActivityViewController {
    func registerForApplicationActiveNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update(_:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }

    @objc func update(_ notification: Notification) {
        let firstItem = IndexPath(row: 0, section: 0)
        if let _ = tableView?.cellForRow(at: firstItem) {
            tableView?.reloadRows(at: [firstItem], with: .fade)
        }
    }

}

extension ActivityViewController: MarginProvider {
    var margin: CGFloat {
        return ringTrailingConstraint.constant
    }
}

extension ActivityViewController: ActivityStoryboard { }

protocol MarginProvider: class {
    var margin: CGFloat { get }
}

class ActivityTableViewDSD: NSObject, UITableViewDelegate, UITableViewDataSource, Reusable {

    // MARK: Variables

    var results: [WeeklyObject]
    var action: ((WeeklyObject) -> Void)
    weak var marginProvider: MarginProvider?


    init(with weeklyObjects: [WeeklyObject], marginProvider: MarginProvider, action: @escaping ((WeeklyObject) -> Void)) {
        self.results = weeklyObjects.reversed()
        self.action = action
        self.marginProvider = marginProvider
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ActivityTableViewCell
        cell.margin = marginProvider?.margin ?? 36

        let viewModel = WeeklyGraphViewModel(results[indexPath.row])
        cell.configure(viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        action(results[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

