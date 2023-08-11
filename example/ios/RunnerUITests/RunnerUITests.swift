import XCTest
import Photos

final class RunnerUITests: XCTestCase {
    func testAllowAccessToAllPhotos() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["XCTest"].tap()

        addUIInterruptionMonitor(withDescription: "\"Gal\" Would Like to Access\nYour Photos") { alert in
            alert.buttons["Allow Access to All Photos"].tap()
            return true
        }
        app.tap()
    }
}
