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

    func testScale() {
        let range = TelegramCharts.Range<Int>(min: 10, max: 20)
        XCTAssertEqual(
            range.scaled(by: 2, from: .center),
            TelegramCharts.Range<Int>(min: 5, max: 25)
        )

        XCTAssertEqual(
            range.scaled(by: 2, from: .top),
            TelegramCharts.Range<Int>(min: 0, max: 20)
        )

        XCTAssertEqual(
            range.scaled(by: 2, from: .bottom),
            TelegramCharts.Range<Int>(min: 10, max: 30)
        )

        XCTAssertEqual(
            TelegramCharts.Range<Int>(min: 0, max: 0).scaled(by: 2, from: .bottom),
            TelegramCharts.Range<Int>(min: 0, max: 0)
        )
    }

    func testClamped() {
        let range = TelegramCharts.Range<Int>(min: -2, max: 10)
        XCTAssertEqual(range.clamped(from: 0, to: 5), TelegramCharts.Range<Int>(min: 0, max: 5))
    }
}

private extension Array where Element == Int {
    static func random(count: Int, min: Int = 1, max: Int = 100) -> [Int] {
        return (0 ..< count).map { _ in
            Int.random(in: min ... max)
        }
    }
}
