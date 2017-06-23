//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MapKit

class SettingsMapViewController: UIViewController, SettingsStoryboard {

    var didUpdateUserLocationOnce = false

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var centerCircleView: CenterCircleView!

    override func viewDidLoad() {
        super.viewDidLoad()

        CLLocationManager().requestAlwaysAuthorization()

    }
}

extension SettingsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        didUpdateUserLocationOnce = true

        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let userZoomedRegion = MKCoordinateRegion(center: userLocation.coordinate,
                                                  span: span)
        mapView.setRegion(userZoomedRegion, animated: true)
    }
}

class CenterCircleView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        context?.addArc(center: center, radius: rect.width / 4.0,
                        startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context?.setStrokeColor(tintColor.cgColor)
        context?.strokePath()
    }
}
