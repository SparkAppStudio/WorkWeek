//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import CoreLocation

enum RegionId: String {
    case home
    case work
}

final class LocationDelegate: NSObject, CLLocationManagerDelegate {

    // TODO: Inject this dependency since other use it
    let notificationManager = NotificationCenterManager.shared

    let pushManager = PushNotificationManager()

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // When user becomes authorized, update their location, so the map will
        // be up to date when they get to it
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.log(.error, String(describing: error))
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let typedRegion = RegionId(rawValue: region.identifier) else {
            Log.log(.error, "Could not create a typed region from \(region.identifier)")
            return
        }
        switch typedRegion {
        case .home:
            notificationManager.postArriveHomeNotification()
        case .work:
            notificationManager.postArriveWorkNotification()
            pushManager.userHasArrivedAtWork()
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let typedRegion = RegionId(rawValue: region.identifier) else {
            Log.log(.error, "Could not create a typed region from \(region.identifier)")
            return
        }
        switch typedRegion {
        case .home:
            notificationManager.postLeaveHomeNotification()
        case .work:
            notificationManager.postLeaveWorkNotification()
            pushManager.userHasDepartedWork()
        }
    }

}
