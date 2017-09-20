//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class OnboardWelcomeViewController: UIViewController, OnboardingStoryboard {
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.onboardWelcome))
    }

}

class OnboardExplainViewController: UIViewController, OnboardingStoryboard {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.onboardExplain))
    }

}


// MARK: LocationVC

protocol OnboardLocationViewDelegate: class {
    func locationPageIsDone()
}

class OnboardLocationViewController: UIViewController, OnboardingStoryboard {

    weak var delegate: OnboardLocationViewDelegate?
    var locationManager: CLLocationManager!

    @IBOutlet weak var grantLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        NotificationCenter.default.addObserver(self,
            selector: #selector(OnboardLocationViewController.appDidBecomeActive(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDisplay()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.onboardLocation))
    }


    func configureDisplay() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            grantLocationButton.isEnabled = false
            grantLocationButton.setTitle("Hooray! Location is Enabled", for: .normal)
            grantLocationButton.backgroundColor = UIColor.clear

            //allow user to proceed only when location access is granted
            delegate?.locationPageIsDone()

        case .denied, .restricted, .authorizedWhenInUse:
            grantLocationButton.isEnabled = true
            grantLocationButton.setTitle("Grant Access", for: .normal)
            grantLocationButton.backgroundColor = #colorLiteral(red: 0.2414106429, green: 0.7961877584, blue: 0.8413593173, alpha: 1)

        case .notDetermined:
            grantLocationButton.isEnabled = true
            grantLocationButton.setTitle("Grant Access", for: .normal)
            grantLocationButton.backgroundColor = #colorLiteral(red: 0.2414106429, green: 0.7961877584, blue: 0.8413593173, alpha: 1)
        }
    }

    @objc func appDidBecomeActive(_ notification: NSNotification) {
        configureDisplay()
    }

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


// MARK: NotifyVC

protocol OnboardNotifyViewDelegate: class {
    func notifyPageIsDone()
}

class OnboardNotifyViewController: UIViewController, OnboardingStoryboard {

    weak var delegate: OnboardNotifyViewDelegate?

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]

    @IBOutlet weak var grantNotifyButton: UIButton!
    @IBOutlet weak var denyNotifyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        NotificationCenter.default.addObserver(self,
            selector: #selector(OnboardLocationViewController.appDidBecomeActive(_:)),
            name: .UIApplicationDidBecomeActive,
            object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDisplay(button: grantNotifyButton)
        configureDisplay(button: denyNotifyButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.onboardNotify))
    }


    @objc func appDidBecomeActive(_ notification: NSNotification) {
        configureDisplay(button: grantNotifyButton)
        configureDisplay(button: denyNotifyButton)
    }

    func configureDisplay(button: UIButton) {
        center.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {

                case .authorized:
                    if button === self.denyNotifyButton {
                        button.isHidden = true
                        break
                    }
                    button.isEnabled = false
                    button.setTitle("Hooray! Notify is Enabled", for: .normal)
                    button.backgroundColor = UIColor.clear

                    //dismiss
                    self.delegate?.notifyPageIsDone()

                case .denied:
                    if button == self.denyNotifyButton {
                        button.isHidden = false
                        break
                    }
                    button.isEnabled = true
                    button.setTitle("Grant Access", for: .normal)
                    button.backgroundColor = #colorLiteral(red: 0.2414106429, green: 0.7961877584, blue: 0.8413593173, alpha: 1)

                case .notDetermined:
                    if button == self.denyNotifyButton {
                        button.isHidden = false
                        break
                    }
                    button.isEnabled = true
                    button.setTitle("Grant Access", for: .normal)
                    button.backgroundColor = #colorLiteral(red: 0.2414106429, green: 0.7961877584, blue: 0.8413593173, alpha: 1)
                }
            }

        }
    }

    // MARK: Actions

    @IBAction func didTapGrantNotify(_ sender: UIButton) {

        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.center.requestAuthorization(options: self.options) { (granted, error) in
                    if granted {
                        self.configureDisplay(button: self.grantNotifyButton)
                        self.configureDisplay(button: self.denyNotifyButton)
                    } else {
                        Log.log(error?.localizedDescription ?? "failed to grant, error")
                        showFailedToGrantPermissionsPopup()
                    }
                }
            } else {
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }

        func showFailedToGrantPermissionsPopup() {

            //show error to user, ask to try again
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oh Noes!",
                                              message: "Error granting access, please try again",
                                              preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }


        // TODO: User default notification choice is none. If they select notifications here
        // we should update the `User` to reflect that they want settings, and shoudl decide
        // that weekly or daily is the default

    }

    @IBAction func didTapDenyNotify(_ sender: UIButton) {
        //dismiss
        delegate?.notifyPageIsDone()
    }
}


// MARK: NotifyVC

protocol OnboardSettingsViewDelegate: class {
    func settingsPageDidTapHome()
    func settingsPageDidTapWork()
}

class OnboardSettingsViewController: UIViewController, OnboardingStoryboard {

    weak var delegate: OnboardSettingsViewDelegate?

    @IBOutlet weak var setHomeButton: UIButton!
    @IBOutlet weak var setWorkButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.onboardSettings))
    }

    @IBAction func didTapHome(_ sender: UIButton) {
        delegate?.settingsPageDidTapHome()
    }

    @IBAction func didTapWork(_ sender: UIButton) {
        delegate?.settingsPageDidTapWork()
    }

}
