//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MapKit

enum MapVCType {
    case home
    case work
}

enum RegionId: String {
    case home
    case work
}

protocol MapVCDelegate: class {
    func save(type: MapVCType, coordinate: CLLocationCoordinate2D, radius: CLLocationDistance)
    func cancel()
}

class SettingsMapViewController: UIViewController, SettingsStoryboard {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var centerCircleView: CenterCircleView!

    var locationManager: CLLocationManager!

    /// Used to ensure we only zoom the map once
    var didUpdateUserLocationOnce = false

    var type = MapVCType.home

    weak var delegate: MapVCDelegate?

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        switch type {
        case .home:
            headerLabel.text = NSLocalizedString("Home", comment: "Settings Map Set Work Location")
        case .work:
            headerLabel.text = NSLocalizedString("Work", comment: "Settings Map Set Work Location")
        }

        drawOverlays(for: type)

        // TODO: Remove this, we should already have authorization when we get here
       locationManager.requestAlwaysAuthorization()
    }

    // MARK: Actions

    @IBAction func didTapDone(_ sender: UIButton) {
        print("Done Tapped")
        let center = mapView.region.center
        // TODO: Figure out how to do this radius math, pretty sure this is wrong
        let radius = mapView.visibleMapRect.size.width / 3 / 2
        delegate?.save(type: type,
                       coordinate: center,
                       radius: radius)
    }

    @IBAction func didTapCancel(_ sender: UIButton) {
        delegate?.cancel()
    }

    func drawOverlays(for type: MapVCType) {
        switch type {
        case .home:
            locationManager.circle(forRegion: RegionId.home.rawValue).forEach(mapView.add(_:))
        case .work:
            locationManager.circle(forRegion: RegionId.work.rawValue).forEach(mapView.add(_:))
        }
    }
}

extension SettingsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        defer { didUpdateUserLocationOnce = true }

        if !didUpdateUserLocationOnce {
            let userZoomedRegion = MKCoordinateRegionMakeWithDistance(
                                        userLocation.coordinate,
                                        1_000, 1_000)

            mapView.setRegion(userZoomedRegion, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(annotation)
        return nil
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print(overlay)
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = .green
        renderer.strokeColor = .purple
        return renderer
    }

}

class CenterCircleView: UIView {
    static var lineWidth: CGFloat = 3.0
    override func draw(_ rect: CGRect) {

        let strokeColor = tintColor.cgColor
        let fillColor = strokeColor.copy(alpha: 0.5) ?? UIColor.clear.cgColor

        let context = UIGraphicsGetCurrentContext()

        let insetRect = rect.insetBy(dx: CenterCircleView.lineWidth,
                                     dy: CenterCircleView.lineWidth)

        context?.setStrokeColor(strokeColor)
        context?.setLineWidth(CenterCircleView.lineWidth)
        context?.strokeEllipse(in: insetRect)

        context?.setFillColor(fillColor)
        context?.fillEllipse(in: insetRect)
    }
}
