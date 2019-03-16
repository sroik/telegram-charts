//
//  Copyright © 2019 sroik. All rights reserved.
//

@testable import TelegramCharts
import XCTest

class RangeTests: XCTestCase {
    func testZeroArrayRange() {
        let array: [Int] = []
        let range = TelegramCharts.Range<Int>(min: 0, max: 0)
        XCTAssertEqual(array.range, range)
    }

    func testRandomArrayRange() {
        let array = [Int].random(count: 100)
        let range = TelegramCharts.Range<Int>(min: array.min() ?? 0, max: array.max() ?? 0)
        XCTAssertEqual(array.range, range)
    }

    func testValueAtPosition() {
        let range = TelegramCharts.Range<Int>(min: 1, max: 11)
        XCTAssertEqual(range.value(at: 0), 1)
        XCTAssertEqual(range.value(at: 1), 11)
        XCTAssertEqual(range.value(at: 0.5), 6)
    }
}

private extension Array where Element == Int {
    static func random(count: Int, min: Int = 1, max: Int = 100) -> [Int] {
        return (0 ..< count).map { _ in
            Int.random(in: min ... max)
        }
    }
}
