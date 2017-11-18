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
    private var countdownTVCIdentifier = "WeeklyGraphCell"

    // MARK: IBOutlets

    @IBOutlet var ringTrailingConstraint: NSLayoutConstraint!
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
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(CountdownViewController.tick(_:))),
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

    private func registerNib() {
//        let nib = UINib(nibName: "WeeklyGraphCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: countdownTVCIdentifier)
        tableView.register(CountdownTableViewCell.self, forCellReuseIdentifier: countdownTVCIdentifier)
    }
}

extension CountdownViewController: MarginProvider {
    var margin: CGFloat {
        return ringTrailingConstraint.constant
    }
}

extension CountdownViewController: ActivityStoryboard { }

protocol MarginProvider: class {
    var margin: CGFloat { get }
}

class CountDownTableViewDSD: NSObject, UITableViewDelegate, UITableViewDataSource {

    // MARK: Variables
    private var countdownTVCIdentifier = "CountdownTableViewCell"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: countdownTVCIdentifier,
                                                 for: indexPath) as! CountdownTableViewCell // swiftlint:disable:this force_cast
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

