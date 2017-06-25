//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class OnboardWelcomeViewController: UIViewController, OnboardingStoryboard {

}

class OnboardExplainViewController: UIViewController, OnboardingStoryboard {

}

class OnboardLocationViewController: UIViewController, OnboardingStoryboard {

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
            selector: #selector(OnboardLocationViewController.appDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }

    func configureDisplay() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            grantLocationButton.isEnabled = false
            grantLocationButton.setTitle("Hooray! Location is Enabled", for: .normal)
            grantLocationButton.backgroundColor = UIColor.clear
        case .denied, .restricted, .authorizedWhenInUse:
            grantLocationButton.isEnabled = true
            grantLocationButton.setTitle("Grant Access", for: .normal)
            grantLocationButton.backgroundColor = UIColor.green

        case .notDetermined:
            grantLocationButton.isEnabled = true
            grantLocationButton.setTitle("Grant Access", for: .normal)
            grantLocationButton.backgroundColor = UIColor.green
        }
    }

    func appDidBecomeActive(notification: NSNotification) {
        configureDisplay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDisplay()
    }

    @IBOutlet weak var grantLocationButton: UIButton!

    @IBAction func didTapGrantLocation(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}

class OnboardNotifyViewController: UIViewController, OnboardingStoryboard {

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
            selector: #selector(OnboardLocationViewController.appDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)

    }

    func appDidBecomeActive(notification: NSNotification) {
        configureDisplay(button: grantNotifyButton)
        configureDisplay(button: denyNotifyButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDisplay(button: grantNotifyButton)
        configureDisplay(button: denyNotifyButton)
    }

    func configureDisplay(button: UIButton) {
        center.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {

                case .authorized:
                    if button == self.denyNotifyButton {
                        button.isHidden = true
                        break
                    }
                    button.isEnabled = false
                    button.setTitle("Hooray! Notify is Enabled", for: .normal)
                    button.backgroundColor = UIColor.clear

                case .denied:
                    if button == self.denyNotifyButton {
                        button.isHidden = false
                        break
                    }
                    button.isEnabled = true
                    button.setTitle("Grant Access", for: .normal)
                    button.backgroundColor = UIColor.green

                case .notDetermined:
                    if button == self.denyNotifyButton {
                        button.isHidden = false
                        break
                    }
                    button.isEnabled = true
                    button.setTitle("Grant Access", for: .normal)
                    button.backgroundColor = UIColor.green
                }
            }

        }
    }

    @IBOutlet weak var grantNotifyButton: UIButton!

    @IBOutlet weak var denyNotifyButton: UIButton!

    @IBAction func didTapGrantNotify(_ sender: UIButton) {

        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.center.requestAuthorization(options: self.options) { (granted, error) in
                    if granted {
                        self.configureDisplay(button: self.grantNotifyButton)
                        self.configureDisplay(button: self.denyNotifyButton)
                        //dismiss
                    } else {
                        print(error ?? "failed to grant, error")
                        //dismiss
                    }
                }
            } else {
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }
    }

    @IBAction func didTapDenyNotify(_ sender: UIButton) {
        //dismiss
    }

}
