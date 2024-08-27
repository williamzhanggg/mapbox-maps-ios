import UIKit
@_spi(Experimental) import MapboxMaps

final class BasicMapExample: UIViewController, ExampleProtocol {
    private var mapView: MapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let cameraOptions = CameraOptions(
            center: CLLocationCoordinate2D(latitude: 41.879, longitude: -87.635),
            zoom: 16,
            bearing: 12,
            pitch: 60)
        let options = MapInitOptions(cameraOptions: cameraOptions)

        mapView = MapView(frame: view.bounds, mapInitOptions: options)

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.ornaments.options.scaleBar.visibility = .visible

        view.addSubview(mapView)

        let targets = [
            FeaturesetQueryTarget(
                featureset: .layer("my-layer"),
                filter: Exp(.eq) {
                    Exp(.get) { "type" }
                    "hotel"
                }
            ),
            FeaturesetQueryTarget(featureset: .featureset("poi", importId: "basemap"))
        ]
        mapView.mapboxMap.queryRenderedFeatures(with: CGPoint(x: 0, y: 0),
                                   targets: targets) { _ in
            // handle features in result
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // The below line is used for internal testing purposes only.
        finish()
    }
}
