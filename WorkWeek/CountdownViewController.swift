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

    // MARK: IBActions
    @IBAction func didTapSettings(_ sender: UIButton) {
        delegate?.countdownPageDidTapSettings()
    }

    weak var delegate: CountdownViewDelegate?
    var data: CountdownData!

    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        blink()
        countdownDisplay.text = hourMinuteFormatter.string(from: data.timeLeftInDay)
        let weekHours = hoursFormatter.string(from: data.timeLeftInWeek)!
        weekTimeDisplay.text = "\(weekHours) work hours left in the week"
        percentLeft.text = "\(data.percentOfWorkRemaining) % left"
    }

    var blinkEnabled = false
    lazy var blinkView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 100, width: 50, height: 50))
        self.view.addSubview(view)
        return view
    }()

    func blink() {
        if blinkEnabled {
            blinkView.backgroundColor = .clear
            blinkEnabled = false
        } else {
            blinkView.backgroundColor = .red
            blinkEnabled = true
        }
    }
}

extension CountdownViewController: ActivityStoryboard { }
