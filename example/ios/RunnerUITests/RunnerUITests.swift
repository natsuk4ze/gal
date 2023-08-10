import XCTest
import Photos

final class RunnerUITests: XCTestCase {
    func testPhotosAuthorization() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Request Access to Album"].tap()

        addUIInterruptionMonitor(withDescription: "\"Gal\" Would Like to Access\nYour Photos") { alert in
            alert.buttons["Allow Access to All Photos"].tap()
            return true
        }
        app.tap()
    }
}
