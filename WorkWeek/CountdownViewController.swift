//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import Reusable

final class CountdownViewController: UIViewController {

    @IBOutlet weak var countdownDisplay: UILabel!

    var timer = Timer()
    var timeRemaining = 28800

    override func viewDidLoad() {
        super.viewDidLoad()
        //By default, start count down from 8 hours
        runTimer()
        #if DEBUG
        // To get shake gesture
        self.becomeFirstResponder()
        #endif
    }

    #if DEBUG
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.navigationController?.presentDevSettingsAlertController()
        }
    }
    #endif

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(CountdownViewController.updateTimer(_:))),
                                     userInfo: nil, repeats: true)
    }

    func updateTimer(_ timer: Timer) {
        if timeRemaining < 1 {
            timer.invalidate()
            //Time is up, do some stuff
        } else {
            timeRemaining -= 1
            countdownDisplay.text = timeString(time: TimeInterval(timeRemaining))
        }
    }

    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

extension CountdownViewController: ActivityStoryboard {
}

