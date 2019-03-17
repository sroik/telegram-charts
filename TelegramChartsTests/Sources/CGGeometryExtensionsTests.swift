//
//  Copyright © 2019 sroik. All rights reserved.
//

@testable import TelegramCharts
import XCTest

class CGGeometryExtensionsTests: XCTestCase {
    func testLimitedWith() {
        let limits = CGRect(x: 10, y: 10, width: 20, height: 20)

        var rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        var expected = CGRect(x: 10, y: 10, width: 10, height: 10)
        XCTAssertEqual(rect.limited(with: limits), expected)

        rect = CGRect(x: 20, y: 20, width: 10, height: 10)
        expected = rect
        XCTAssertEqual(rect.limited(with: limits), expected)

        rect = CGRect(x: 20, y: 20, width: 20, height: 20)
        expected = CGRect(x: 10, y: 10, width: 20, height: 20)
        XCTAssertEqual(rect.limited(with: limits), expected)
    }
}
