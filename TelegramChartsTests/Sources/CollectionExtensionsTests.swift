//
//  Copyright © 2019 sroik. All rights reserved.
//

@testable import TelegramCharts
import XCTest

class CollectionExtensionsTests: XCTestCase {
    func testIndexNearestToWithRound() {
        let array = Array(0 ... 2)
        XCTAssertEqual(array.index(nearestTo: 0.0), 0)
        XCTAssertEqual(array.index(nearestTo: 0.32), 0)
        XCTAssertEqual(array.index(nearestTo: 0.34), 1)
        XCTAssertEqual(array.index(nearestTo: 0.65), 1)
        XCTAssertEqual(array.index(nearestTo: 0.67), 2)
        XCTAssertEqual(array.index(nearestTo: 1.0), 2)
    }

    func testIndexNearestToWithUp() {
        let array = Array(0 ... 2)
        XCTAssertEqual(array.index(nearestTo: 0.0, rule: .up), 0)
        XCTAssertEqual(array.index(nearestTo: 0.15, rule: .up), 0)
        XCTAssertEqual(array.index(nearestTo: 0.34, rule: .up), 1)
        XCTAssertEqual(array.index(nearestTo: 0.49, rule: .up), 1)
        XCTAssertEqual(array.index(nearestTo: 0.51, rule: .up), 2)
        XCTAssertEqual(array.index(nearestTo: 1.0, rule: .up), 2)
    }

    func testIndexNearestToWithDown() {
        let array = Array(0 ... 2)
        XCTAssertEqual(array.index(nearestTo: 0.0, rule: .down), 0)
        XCTAssertEqual(array.index(nearestTo: 0.49, rule: .down), 0)
        XCTAssertEqual(array.index(nearestTo: 0.7, rule: .down), 1)
        XCTAssertEqual(array.index(nearestTo: 0.85, rule: .down), 2)
        XCTAssertEqual(array.index(nearestTo: 1.0, rule: .down), 2)
    }
}
