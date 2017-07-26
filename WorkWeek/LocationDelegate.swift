//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationDelegate: NSObject, CLLocationManagerDelegate {

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
            NotificationCenterManager.shared.postArriveHomeNotification()
        case .work:
            NotificationCenterManager.shared.postArriveWorkNotification()
            pushManager.userHasArrivedAtWork()
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let typedRegion = RegionId(rawValue:region.identifier) else {
            Log.log(.error, "Could not create a typed region from \(region.identifier)")
            return
        }
        switch typedRegion {
        case .home:
            NotificationCenterManager.shared.postLeaveHomeNotification()
        case .work:
            NotificationCenterManager.shared.postLeaveWorkNotification()
            pushManager.userHasDepartedWork()
        }
    }

}
