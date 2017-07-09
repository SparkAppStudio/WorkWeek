//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MapKit

// TODO: Combine these 2 enums?
enum MapVCType {
    case home
    case work
}

enum RegionId: String {
    case home
    case work
}

class SettingsMapViewController: UIViewController, SettingsStoryboard, UISearchBarDelegate {

    static func push(onto: UINavigationController, as type: MapVCType, location: CLLocationManager, delegate: MapVCDelegate) {
        let mapViewController = SettingsMapViewController.instantiate()
        mapViewController.locationManager = location
        mapViewController.type = type
        mapViewController.delegate = delegate
        onto.pushViewController(mapViewController, animated: true)
    }

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

        searchBar.delegate = self

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
        let center = mapView.region.center
        let radius = mapView.visibleMapRect.sizeInMeters().width / 3.0 / 2.0
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
            locationManager.circles(matching: RegionId.home.rawValue).forEach(mapView.add(_:))
        case .work:
            locationManager.circles(matching: RegionId.work.rawValue).forEach(mapView.add(_:))
        }
    }

    // MARK: Search Bar Delegate

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
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

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        renderer.strokeColor = .clear
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

extension MKMapRect {
    struct Size {
        let width: CLLocationDistance
        let height: CLLocationDistance
    }
    func sizeInMeters() -> Size {
        let topLeft = self.origin
        let topRight = MKMapPoint(x: topLeft.x + self.size.width,
                                   y: topLeft.y)
        let width = MKMetersBetweenMapPoints(topLeft, topRight)

        let bottomLeft = MKMapPoint(x: topLeft.x, y: topLeft.y + self.size.height)

        let height = MKMetersBetweenMapPoints(topLeft, bottomLeft)

        return Size(width: width, height: height)
    }
}
