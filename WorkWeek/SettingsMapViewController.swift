//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit
import MapKit
import Contacts

enum MapVCType {
    case home
    case work
}

class SettingsMapViewController: UIViewController, SettingsStoryboard, UISearchBarDelegate {

    static func presentMapWith(navController: UINavigationController,
                               as type: MapVCType,
                               location: CLLocationManager,
                               delegate: MapVCDelegate,
                               user: User,
                               day: DailyObject?) {
        let mapViewController = SettingsMapViewController.instantiate()
        mapViewController.locationManager = location
        mapViewController.user = user
        mapViewController.day = day
        mapViewController.type = type
        mapViewController.delegate = delegate
        navController.present(mapViewController, animated: true)
    }

    @IBOutlet weak var saveButton: ThemeWorkButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var wasLabel: UILabel!
    @IBOutlet weak var nowAddressLabel: UILabel!
    @IBOutlet weak var wasAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var centerCircleView: CenterCircleView!

    var locationManager: CLLocationManager!
    var geoCoder = CLGeocoder()

    /// Used to ensure we only zoom the map once
    var didUpdateUserLocationOnce = false
    var user: User! //provided by coordinator
    var day: DailyObject? //provided by coordinator, you won't get one from onboarding however
    var type = MapVCType.home

    weak var delegate: MapVCDelegate?

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user != nil, "User should be provided by the Coordinator")

        setTheme(isNavBarTransparent: true)
        zoomMap()

        searchBar.delegate = self

        drawOverlays(for: type)
        setAndThemeLabels()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(.pageView(.settingsMap))
    }

    func setAndThemeLabels() {
        for label in [headerLabel, nowLabel, wasLabel, nowAddressLabel, wasAddressLabel] {
            label?.textColor = UIColor.themeText()
        }

        searchBar.barTintColor = UIColor.themeBackground()
        switch type {
        case .home:
            saveButton.borderColor = UIColor.homeGreen()
            saveButton.setNeedsDisplay()
            centerCircleView.strokeColor = UIColor.homeGreen().cgColor
            centerCircleView.fillColor = UIColor.homeGreen().withAlphaComponent(0.1).cgColor
            centerCircleView.setNeedsDisplay()
            headerLabel.text = NSLocalizedString("Home", comment: "Settings Map Set Work Location")
            title = NSLocalizedString("Home", comment: "Settings Map Set Work Location")
            wasAddressLabel.text = user.homeLocation
        case .work:
            headerLabel.text = NSLocalizedString("Work", comment: "Settings Map Set Work Location")
            title = NSLocalizedString("Work", comment: "Settings Map Set Work Location")
            wasAddressLabel.text = user.workLocation
        }
    }


    // MARK: Actions

    @IBAction func didTapDone(_ sender: UIButton) {

        let center = mapView.region.center
        let radius = mapView.visibleMapRect.sizeInMeters().width / 3.0 / 2.0
        delegate?.save(viewController: self, type: type,
                       user: user, day: day,
                       address: nowAddressLabel.text,
                       coordinate: center,
                       radius: radius)
    }

    @IBAction func didTapCancel(_ sender: UIButton) {
        delegate?.cancel(viewController: self)
    }

    // MARK: - Members
    func zoomMap() {
        defer { didUpdateUserLocationOnce = true }

        if let coord = locationManager.location?.coordinate {
            let userZoomedRegion = MKCoordinateRegionMakeWithDistance(
                coord,
                1_000, 1_000)

            mapView.setRegion(userZoomedRegion, animated: false)
        }
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, searchText != "" else {
            Log.log("Exiting search early. `searchBar.text` is nil or empty")
            return
        }

        Log.log("Searching map \(type), for: \(String(describing: searchBar.text))")

        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = mapView.region

        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.startResult {[weak self] result  in
            self?.handleSearchResult(result)
        }
    }

    func handleSearchResult(_ result: MKLocalSearch.SearchResult) {
        switch result {
        case .success(let response):
            let placemarks = response.mapItems.map { $0.placemark }
            mapView.showAnnotations(placemarks, animated: true)
        case .failure(let typedError):
            switch typedError {
            case .bothResponseAndErrorNil:
                Log.log(.error, "Attempted search, got no error and no response")
            case .error(let err):
                Log.log(.error, "System Error when searching: \(err.localizedDescription)")
            }
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

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.lineWidth = 2
        switch type {
        case .home:
            renderer.fillColor = UIColor.homeGreen().withAlphaComponent(0.3)
            renderer.strokeColor = UIColor.homeGreen()
        case .work:
            renderer.fillColor = UIColor.workBlue().withAlphaComponent(0.3)
            renderer.strokeColor = UIColor.workBlue()
        }
        return renderer
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            guard error == nil else { return }
            for placeMark in placeMarks! {
                guard let postalAddress = placeMark.postalAddress else { return }
                let addressString = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                self.nowAddressLabel.text = addressString
            }
        }
    }

}


class CenterCircleView: UIView {
    static var lineWidth: CGFloat = 2.0
    var strokeColor: CGColor = UIColor.workBlue().cgColor
    var fillColor: CGColor = UIColor.workBlue().withAlphaComponent(0.1).cgColor

    override func draw(_ rect: CGRect) {

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

        let bottomLeft = MKMapPoint(x: topLeft.x,
                                    y: topLeft.y + self.size.height)
        let height = MKMetersBetweenMapPoints(topLeft, bottomLeft)

        return Size(width: width, height: height)
    }
}
