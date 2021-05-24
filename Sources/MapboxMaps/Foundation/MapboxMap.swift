import MapboxCoreMaps
import Turf
import UIKit
@_implementationOnly import MapboxCommon_Private

public final class MapboxMap {
    /// The underlying renderer object responsible for rendering the map
    public let __map: Map

    internal var size: CGSize {
        get {
            CGSize(__map.getSize())
        }
        set {
            __map.setSizeFor(Size(newValue))
        }
    }

    /// The `style` object supports run time styling.
    public internal(set) var style: Style

    private var eventHandlers = WeakSet<MapEventHandler>()

    deinit {
        eventHandlers.allObjects.forEach {
            $0.cancel()
        }
    }

    internal init(mapClient: MapClient, mapInitOptions: MapInitOptions) {
        __map = Map(
            client: mapClient,
            mapOptions: mapInitOptions.mapOptions,
            resourceOptions: mapInitOptions.resourceOptions)
        __map.createRenderer()

        style = Style(with: __map)
    }

    // MARK: - Style loading
    private func observeStyleLoad(_ completion: @escaping (Result<Style, Error>) -> Void) {
        onNext(eventTypes: [.styleLoaded, .mapLoadingError]) { event in
            switch event.type {
            case MapEvents.styleLoaded:
                if !self.style.isLoaded {
                    Log.warning(forMessage: "style.isLoaded == false, was this an empty style?", category: "Style")
                }
                completion(.success(self.style))

            case MapEvents.mapLoadingError:
                let error = MapLoadingError(data: event.data)
                completion(.failure(error))

            default:
                fatalError("Unexpected event type")
            }
        }
    }

    /// Loads a style from a StyleURI, calling a completion closure when the
    /// style is fully loaded or there has been an error during load.
    ///
    /// - Parameters:
    ///   - styleURI: StyleURI to load
    ///   - completion: Closure called when the style has been fully loaded. The
    ///     `Result` type encapsulates the `Style` or error that occurred. See
    ///     `MapLoadingError`
    public func loadStyleURI(_ styleURI: StyleURI, completion: ((Result<Style, Error>) -> Void)? = nil) {
        if let completion = completion {
            observeStyleLoad(completion)
        }
        __map.setStyleURIForUri(styleURI.rawValue)
    }

    /// Loads a style from a JSON string, calling a completion closure when the
    /// style is fully loaded or there has been an error during load.
    ///
    /// - Parameters:
    ///   - styleURI: Style JSON string
    ///   - completion: Closure called when the style has been fully loaded. The
    ///     `Result` type encapsulates the `Style` or error that occurred. See
    ///     `MapLoadingError`
    public func loadStyleJSON(_ JSON: String, completion: ((Result<Style, Error>) -> Void)? = nil) {
        if let completion = completion {
            observeStyleLoad(completion)
        }
        __map.setStyleJSONForJson(JSON)
    }

    // MARK: - Camera Fitting

    /// Transforms a view's frame into a set of coordinate bounds
    /// - Parameter rect: The `rect` whose bounds will be transformed into a set of map coordinate bounds.
    /// - Returns: A `CoordinateBounds` object that represents the southwest and northeast corners of the view's bounds.
    public func coordinateBounds(for rect: CGRect) -> CoordinateBounds {
        let topRight = coordinate(for: CGPoint(x: rect.maxX, y: rect.minY)).wrap()
        let bottomLeft = coordinate(for: CGPoint(x: rect.minX, y: rect.maxY)).wrap()

        let southwest = CLLocationCoordinate2D(latitude: bottomLeft.latitude, longitude: bottomLeft.longitude)
        let northeast = CLLocationCoordinate2D(latitude: topRight.latitude, longitude: topRight.longitude)

        return CoordinateBounds(southwest: southwest, northeast: northeast)
    }

    /// Transforms a set of map coordinate bounds to a `CGRect` relative to the `MapView`.
    /// - Parameter coordinateBounds: The `coordinateBounds` that will be converted into a rect relative to the `MapView`
    /// - Returns: A `CGRect` whose corners represent the vertices of a set of `CoordinateBounds`.
    public func rect(for coordinateBounds: CoordinateBounds) -> CGRect {
        let southwest = coordinateBounds.southwest.wrap()
        let northeast = coordinateBounds.northeast.wrap()

        var rect = CGRect.zero

        let swPoint = point(for: southwest)
        let nePoint = point(for: northeast)

        rect = CGRect(origin: swPoint, size: CGSize.zero)

        rect = rect.extend(from: nePoint)

        return rect
    }
}

// MARK: - CameraManagerProtocol -

extension MapboxMap: CameraManagerProtocol {

    public func camera(for coordinateBounds: CoordinateBounds,
                       padding: UIEdgeInsets,
                       bearing: Double?,
                       pitch: Double?) -> CameraOptions {
        return CameraOptions(
            __map.cameraForCoordinateBounds(
                for: coordinateBounds,
                padding: padding.toMBXEdgeInsetsValue(),
                bearing: bearing?.NSNumber,
                pitch: pitch?.NSNumber))
    }

    public func camera(for coordinates: [CLLocationCoordinate2D],
                       padding: UIEdgeInsets,
                       bearing: Double?,
                       pitch: Double?) -> CameraOptions {
        return CameraOptions(
            __map.cameraForCoordinates(
                forCoordinates: coordinates.map(\.location),
                padding: padding.toMBXEdgeInsetsValue(),
                bearing: bearing?.NSNumber,
                pitch: pitch?.NSNumber))
    }

    public func camera(for coordinates: [CLLocationCoordinate2D],
                       camera: CameraOptions,
                       rect: CGRect) -> CameraOptions {
        return CameraOptions(
            __map.cameraForCoordinates(
                forCoordinates: coordinates.map(\.location),
                camera: MapboxCoreMaps.CameraOptions(camera),
                box: ScreenBox(rect)))
    }

    public func camera(for geometry: Turf.Geometry,
                       padding: UIEdgeInsets,
                       bearing: CGFloat?,
                       pitch: CGFloat?) -> CameraOptions {
        return CameraOptions(
            __map.cameraForGeometry(
                for: Geometry(geometry: geometry),
                padding: padding.toMBXEdgeInsetsValue(),
                bearing: bearing?.NSNumber,
                pitch: pitch?.NSNumber))
    }

    // MARK: - CameraOptions to CoordinateBounds

    public func coordinateBounds(for camera: CameraOptions) -> CoordinateBounds {
        return __map.coordinateBoundsForCamera(
            forCamera: MapboxCoreMaps.CameraOptions(camera))
    }

    public func coordinateBoundsZoom(for camera: CameraOptions) -> CoordinateBoundsZoom {
        return __map.coordinateBoundsZoomForCamera(forCamera: MapboxCoreMaps.CameraOptions(camera))
    }

    public func coordinateBoundsZoomUnwrapped(for camera: CameraOptions) -> CoordinateBoundsZoom {
        return __map.coordinateBoundsZoomForCameraUnwrapped(forCamera: MapboxCoreMaps.CameraOptions(camera))
    }

    public func coordinate(for point: CGPoint) -> CLLocationCoordinate2D {
        return __map.coordinateForPixel(forPixel: point.screenCoordinate)
    }

    public func point(for coordinate: CLLocationCoordinate2D) -> CGPoint {
        return __map.pixelForCoordinate(for: coordinate).point
    }

    public func points(for coordinates: [CLLocationCoordinate2D]) -> [CGPoint] {
        let locations = coordinates.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        let screenCoords = __map.pixelsForCoordinates(forCoordinates: locations)
        return screenCoords.map { $0.point }
    }

    public func coordinates(for points: [CGPoint]) -> [CLLocationCoordinate2D] {
        let screenCoords = points.map { $0.screenCoordinate }
        let locations = __map.coordinatesForPixels(forPixels: screenCoords)
        return locations.map { $0.coordinate }
    }

    // MARK: - Camera options setters/getters

    public func _setCamera(to cameraOptions: CameraOptions) {
        __map.setCameraFor(MapboxCoreMaps.CameraOptions(cameraOptions))
    }

    public var cameraState: CameraState {
        return CameraState(__map.getCameraState())
    }

    public var freeCameraOptions: FreeCameraOptions {
        get {
            return __map.getFreeCameraOptions()
        }
        set {
            __map.setCameraFor(newValue)
        }
    }

    /// Returns the bounds of the map.
    public var cameraBounds: CameraBounds {
        return __map.getBounds()
    }

    // MARK: - Drag API

    public func dragStart(for point: CGPoint) {
        __map.dragStart(forPoint: point.screenCoordinate)
    }

    public func dragCameraOptions(from: CGPoint, to: CGPoint) -> CameraOptions {
        let options = __map.getDragCameraOptionsFor(fromPoint: from.screenCoordinate,
                                                    toPoint: to.screenCoordinate)
        return CameraOptions(options)
    }

    public func dragEnd() {
        __map.dragEnd()
    }
}

// MARK: - MapFeatureQueryable -

// TODO: Turf feature property of QueriedFeature
extension MapboxMap: MapFeatureQueryable {
    public func queryRenderedFeatures(for shape: [CGPoint], options: RenderedQueryOptions? = nil, completion: @escaping (Result<[QueriedFeature], Error>) -> Void) {
        __map.queryRenderedFeatures(forShape: shape.map { $0.screenCoordinate },
                                    options: options ?? RenderedQueryOptions(layerIds: nil, filter: nil),
                                    callback: coreAPIClosureAdapter(for: completion,
                                                                    type: NSArray.self,
                                                                    concreteErrorType: MapError.self))
    }

    public func queryRenderedFeatures(in rect: CGRect, options: RenderedQueryOptions? = nil, completion: @escaping (Result<[QueriedFeature], Error>) -> Void) {
        __map.queryRenderedFeatures(for: ScreenBox(rect),
                                    options: options ?? RenderedQueryOptions(layerIds: nil, filter: nil),
                                    callback: coreAPIClosureAdapter(for: completion,
                                                                    type: NSArray.self,
                                                                    concreteErrorType: MapError.self))
    }

    public func queryRenderedFeatures(at point: CGPoint, options: RenderedQueryOptions? = nil, completion: @escaping (Result<[QueriedFeature], Error>) -> Void) {
        __map.queryRenderedFeatures(forPixel: point.screenCoordinate,
                                    options: options ?? RenderedQueryOptions(layerIds: nil, filter: nil),
                                    callback: coreAPIClosureAdapter(for: completion,
                                                                    type: NSArray.self,
                                                                    concreteErrorType: MapError.self))
    }

    public func querySourceFeatures(for sourceId: String,
                                    options: SourceQueryOptions,
                                    completion: @escaping (Result<[QueriedFeature], Error>) -> Void) {
        __map.querySourceFeatures(forSourceId: sourceId,
                                  options: options,
                                  callback: coreAPIClosureAdapter(for: completion,
                                                                  type: NSArray.self,
                                                                  concreteErrorType: MapError.self))
    }

    public func queryFeatureExtension(for sourceId: String,
                                      feature: Turf.Feature,
                                      extension: String,
                                      extensionField: String,
                                      args: [String: Any]? = nil,
                                      completion: @escaping (Result<FeatureExtensionValue, Error>) -> Void) {

        guard let feature = Feature(feature) else {
            completion(.failure(TypeConversionError.unexpectedType))
            return
        }

        __map.queryFeatureExtensions(forSourceIdentifier: sourceId,
                                     feature: feature,
                                     extension: `extension`,
                                     extensionField: extensionField,
                                     args: args,
                                     callback: coreAPIClosureAdapter(for: completion,
                                                                     type: FeatureExtensionValue.self,
                                                                     concreteErrorType: MapError.self))
    }
}

// MARK: - ObservableProtocol -

extension MapboxMap: ObservableProtocol {
    public func subscribe(_ observer: Observer, events: [String]) {
        __map.subscribe(for: observer, events: events)
    }

    public func unsubscribe(_ observer: Observer, events: [String] = []) {
        if events.isEmpty {
            __map.unsubscribe(for: observer)
        } else {
            __map.unsubscribe(for: observer, events: events)
        }
    }
}

// MARK: - Map Event handling -

extension MapboxMap: MapEventsObservable {

    @discardableResult
    private func onNext(eventTypes: [MapEvents.EventKind], handler: @escaping (Event) -> Void) -> Cancelable {
        let rawTypes = eventTypes.map { $0.rawValue }
        let handler = MapEventHandler(for: rawTypes,
                                      observable: self) { event in
            handler(event)
            return true
        }
        eventHandlers.add(handler)
        return handler
    }

    @discardableResult
    public func onNext(_ eventType: MapEvents.EventKind, handler: @escaping (Event) -> Void) -> Cancelable {
        return onNext(eventTypes: [eventType], handler: handler)
    }

    @discardableResult
    public func onEvery(_ eventType: MapEvents.EventKind, handler: @escaping (Event) -> Void) -> Cancelable {
        let handler = MapEventHandler(for: [eventType.rawValue],
                                      observable: self) { event in
            handler(event)
            return false
        }
        eventHandlers.add(handler)
        return handler
    }
}
