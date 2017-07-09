//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import CoreLocation


/// A delegate protocol which is to be adopted by objects wishing to be notified
/// when a Map View Controller is finished showing it's content.
///
/// NOTE:
/// There are default implimentations of this Delegate protocol which can be of 
/// some use for the simplest case.
///
/// The default `save` implimentation, creates a new geofence to be tracked by
/// the location manager, and then pops the map VC off the navigation stack.
///
/// The default `cancel` simply pops the map VC off the navigation stack.
protocol MapVCDelegate: class {
    var navigationController: UINavigationController { get }
    var locationManager: CLLocationManager { get }

    /// The Map View Controller calls this delegate method when the user chooses
    /// to save their new geofence
    ///
    /// - Parameters:
    ///   - type: either .home or .work
    ///   - coordinate: The coordinate, a the center of the map (probably used
    ///                 to set the center of a geofence
    ///   - radius: the radius shown by the circle in the middle of the map
    func save(type: MapVCType, coordinate: CLLocationCoordinate2D, radius: CLLocationDistance)

    /// The Map View Controller calls this method when the user chooses not to
    /// save their work. The user probably just wants to dismiss the map.
    func cancel()
}

extension MapVCDelegate {
    func save(type: MapVCType, coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let region: CLRegion
        switch type {
        case .home:
            region = CLCircularRegion(center: coordinate, radius: radius, identifier: RegionId.home.rawValue)
        case .work:
            region = CLCircularRegion(center: coordinate, radius: radius, identifier: RegionId.work.rawValue)
        }
        locationManager.startMonitoring(for: region)
        navigationController.popViewController(animated: true)
    }

    func cancel() {
        navigationController.popViewController(animated: true)
    }
}
