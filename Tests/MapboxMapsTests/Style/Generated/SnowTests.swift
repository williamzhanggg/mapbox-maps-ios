// This file is generated
import XCTest
@_spi(Experimental) @testable import MapboxMaps

final class SnowTests: XCTestCase {

    func testSnowProperties() {
        var instance = Snow()
        instance.centerThinning = .testConstantValue()
        instance.centerThinningTransition = .testConstantValue()
        instance.color = .testConstantValue()
        instance.colorTransition = .testConstantValue()
        instance.density = .testConstantValue()
        instance.densityTransition = .testConstantValue()
        instance.direction = .testConstantValue()
        instance.directionTransition = .testConstantValue()
        instance.intensity = .testConstantValue()
        instance.intensityTransition = .testConstantValue()
        instance.opacity = .testConstantValue()
        instance.opacityTransition = .testConstantValue()
        instance.vignette = .testConstantValue()
        instance.vignetteTransition = .testConstantValue()

        XCTAssertEqual(instance.centerThinning, .testConstantValue())
        XCTAssertEqual(instance.centerThinningTransition, .testConstantValue())
        XCTAssertEqual(instance.color, .testConstantValue())
        XCTAssertEqual(instance.colorTransition, .testConstantValue())
        XCTAssertEqual(instance.density, .testConstantValue())
        XCTAssertEqual(instance.densityTransition, .testConstantValue())
        XCTAssertEqual(instance.direction, .testConstantValue())
        XCTAssertEqual(instance.directionTransition, .testConstantValue())
        XCTAssertEqual(instance.intensity, .testConstantValue())
        XCTAssertEqual(instance.intensityTransition, .testConstantValue())
        XCTAssertEqual(instance.opacity, .testConstantValue())
        XCTAssertEqual(instance.opacityTransition, .testConstantValue())
        XCTAssertEqual(instance.vignette, .testConstantValue())
        XCTAssertEqual(instance.vignetteTransition, .testConstantValue())
    }

    func testSnowSetters() {
        let instance = Snow()
            .centerThinning(Double.testConstantValue())
            .centerThinningTransition(.testConstantValue())
            .color(StyleColor.testConstantValue())
            .colorTransition(.testConstantValue())
            .density(Double.testConstantValue())
            .densityTransition(.testConstantValue())
            .direction(azimuthal: 0, polar: 1)
            .directionTransition(.testConstantValue())
            .intensity(Double.testConstantValue())
            .intensityTransition(.testConstantValue())
            .opacity(Double.testConstantValue())
            .opacityTransition(.testConstantValue())
            .vignette(Double.testConstantValue())
            .vignetteTransition(.testConstantValue())

        XCTAssertEqual(instance.centerThinning, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(instance.centerThinningTransition, .testConstantValue())
        XCTAssertEqual(instance.color, Value.constant(StyleColor.testConstantValue()))
        XCTAssertEqual(instance.colorTransition, .testConstantValue())
        XCTAssertEqual(instance.density, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(instance.densityTransition, .testConstantValue())
        XCTAssertEqual(instance.direction, Value.constant([0, 1]))
        XCTAssertEqual(instance.directionTransition, .testConstantValue())
        XCTAssertEqual(instance.intensity, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(instance.intensityTransition, .testConstantValue())
        XCTAssertEqual(instance.opacity, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(instance.opacityTransition, .testConstantValue())
        XCTAssertEqual(instance.vignette, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(instance.vignetteTransition, .testConstantValue())
    }

    func testSnowPropertySerialization() throws {
        var instance = Snow()
        instance.centerThinning = .testConstantValue()
        instance.centerThinningTransition = .testConstantValue()
        instance.color = .testConstantValue()
        instance.colorTransition = .testConstantValue()
        instance.density = .testConstantValue()
        instance.densityTransition = .testConstantValue()
        instance.direction = .testConstantValue()
        instance.directionTransition = .testConstantValue()
        instance.intensity = .testConstantValue()
        instance.intensityTransition = .testConstantValue()
        instance.opacity = .testConstantValue()
        instance.opacityTransition = .testConstantValue()
        instance.vignette = .testConstantValue()
        instance.vignetteTransition = .testConstantValue()

        let data = try JSONEncoder().encode(instance)
        let decodedInstance = try JSONDecoder().decode(Snow.self, from: data)

        XCTAssertEqual(decodedInstance.centerThinning, .testConstantValue())
        XCTAssertEqual(decodedInstance.centerThinningTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.color, .testConstantValue())
        XCTAssertEqual(decodedInstance.colorTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.density, .testConstantValue())
        XCTAssertEqual(decodedInstance.densityTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.direction, .testConstantValue())
        XCTAssertEqual(decodedInstance.directionTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.intensity, .testConstantValue())
        XCTAssertEqual(decodedInstance.intensityTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.opacity, .testConstantValue())
        XCTAssertEqual(decodedInstance.opacityTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.vignette, .testConstantValue())
        XCTAssertEqual(decodedInstance.vignetteTransition, .testConstantValue())
    }

    func testSnowSettersSerialization() throws {
        let instance = Snow()
            .centerThinning(Double.testConstantValue())
            .centerThinningTransition(.testConstantValue())
            .color(StyleColor.testConstantValue())
            .colorTransition(.testConstantValue())
            .density(Double.testConstantValue())
            .densityTransition(.testConstantValue())
            .direction(azimuthal: 0, polar: 1)
            .directionTransition(.testConstantValue())
            .intensity(Double.testConstantValue())
            .intensityTransition(.testConstantValue())
            .opacity(Double.testConstantValue())
            .opacityTransition(.testConstantValue())
            .vignette(Double.testConstantValue())
            .vignetteTransition(.testConstantValue())

        let data = try JSONEncoder().encode(instance)
        let decodedInstance = try JSONDecoder().decode(Snow.self, from: data)

        XCTAssertEqual(decodedInstance.centerThinning, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(decodedInstance.centerThinningTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.color, Value.constant(StyleColor.testConstantValue()))
        XCTAssertEqual(decodedInstance.colorTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.density, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(decodedInstance.densityTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.direction, Value.constant([0, 1]))
        XCTAssertEqual(decodedInstance.directionTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.intensity, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(decodedInstance.intensityTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.opacity, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(decodedInstance.opacityTransition, .testConstantValue())
        XCTAssertEqual(decodedInstance.vignette, Value.constant(Double.testConstantValue()))
        XCTAssertEqual(decodedInstance.vignetteTransition, .testConstantValue())
    }
}

// End of generated file
