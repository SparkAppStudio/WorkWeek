//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import CoreLocation
import MapKit

extension CLLocationManager {

    /// Created MKCircles from the currently monitored regions
    /// This is super useful for quickly showing the App's currently geofenced
    /// regions on a map. Searches for a prefix string, and attempts to cast to
    /// `CLCircularRegion`.
    ///
    /// Usage
    /// =====
    /// let locationManger = CLLocationManager()
    /// let circles = location.circle(forRegion: "work")
    /// circles.forEach { mapView.add(_:) }
    ///
    /// - Parameter identifier: A prefix which filters the currently monitored regions
    ///                         usefull for only getting the work or home locations
    /// - Returns: An array of circles, could be empty if no regions were found
    func circles(matching identifier: String) -> [MKCircle] {

        let matchingRegions = monitoredRegions.filter { $0.identifier.hasPrefix(identifier) }
        guard matchingRegions.count > 0 else {
            Log.log("No \(identifier) Region Currently Registed, only \(monitoredRegions)")
            return []
        }

        let circles = matchingRegions.flatMap { $0 as? CLCircularRegion }
        guard circles.count > 0 else {
            Log.log("Found \(matchingRegions), but its not a CLCircularRegion")
            return []
        }
        return circles.map { MKCircle(center: $0.center, radius: $0.radius) }
    }
}

extension MKLocalSearch {
    typealias SearchResult = Result<MKLocalSearchResponse, SearchErrors>
    enum Result<T, Error> {
        case success(T)
        case failure(Error)
    }
    enum SearchErrors {
        case bothResponseAndErrorNil
        case error(Error)
    }
    func startResult(completionHandler: @escaping (SearchResult) -> Void) {
        start(completionHandler: { (response, error) in
            if let error = error {
                completionHandler(.failure(.error(error)))
                return
            }
            guard let response = response else {
                let err = SearchErrors.bothResponseAndErrorNil
                completionHandler(.failure(err))
                return
            }
            completionHandler(.success(response))
        })
    }
}
