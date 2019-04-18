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
        let range = TelegramCharts.Range<CGFloat>(min: 10, max: 20)
        XCTAssertEqual(
            range.scaled(by: 2, from: .center),
            TelegramCharts.Range<CGFloat>(min: 5, max: 25)
        )

        XCTAssertEqual(
            range.scaled(by: 2, from: .top),
            TelegramCharts.Range<CGFloat>(min: 0, max: 20)
        )

        XCTAssertEqual(
            range.scaled(by: 2, from: .bottom),
            TelegramCharts.Range<CGFloat>(min: 10, max: 30)
        )

        XCTAssertEqual(
            TelegramCharts.Range<CGFloat>(min: 0, max: 0).scaled(by: 2, from: .bottom),
            TelegramCharts.Range<CGFloat>(min: 0, max: 0)
        )
    }

    func testClamped() {
        let range = TelegramCharts.Range<Int>(min: -2, max: 10)
        XCTAssertEqual(
            range.clamped(from: 0, to: 5),
            TelegramCharts.Range<Int>(min: 0, max: 5)
        )
    }

    func testLimited() {
        let range = TelegramCharts.Range<Int>(min: 5, max: 12)
        XCTAssertEqual(
            range.limited(from: 0, to: 10),
            TelegramCharts.Range<Int>(min: 3, max: 10)
        )

        XCTAssertEqual(
            range.limited(from: 13, to: 15),
            TelegramCharts.Range<Int>(min: 13, max: 15)
        )

        XCTAssertEqual(
            range.limited(from: 10, to: 20),
            TelegramCharts.Range<Int>(min: 10, max: 17)
        )

        XCTAssertEqual(
            range.limited(from: 7, to: 12),
            TelegramCharts.Range<Int>(min: 7, max: 12)
        )

        XCTAssertEqual(
            range.limited(from: 5, to: 10),
            TelegramCharts.Range<Int>(min: 5, max: 10)
        )
    }

    func testPrettyNumbers() {
        XCTAssertEqual(CGFloat(0.0).nextPretty(), 0)
        XCTAssertEqual(CGFloat(1.3).nextPretty(), 2)
        XCTAssertEqual(CGFloat(2.0).nextPretty(), 2)
        XCTAssertEqual(CGFloat(2.1).nextPretty(), 5)
        XCTAssertEqual(CGFloat(5.1).nextPretty(), 10)
        XCTAssertEqual(CGFloat(10).nextPretty(), 10)

        XCTAssertEqual(CGFloat(10.0).nextPretty(), 10)
        XCTAssertEqual(CGFloat(11.2).nextPretty(), 12)
        XCTAssertEqual(CGFloat(12.2).nextPretty(), 15)
        XCTAssertEqual(CGFloat(15.1).nextPretty(), 20)

        XCTAssertEqual(CGFloat(31.2).nextPretty(), 32)
        XCTAssertEqual(CGFloat(32.2).nextPretty(), 35)
        XCTAssertEqual(CGFloat(37).nextPretty(), 40)
        XCTAssertEqual(CGFloat(99).nextPretty(), 100)

        XCTAssertEqual(CGFloat(101).nextPretty(), 110)
        XCTAssertEqual(CGFloat(109).nextPretty(), 110)
        XCTAssertEqual(CGFloat(121).nextPretty(), 150)

        XCTAssertEqual(CGFloat(1009).nextPretty(), 1100)
        XCTAssertEqual(CGFloat(1019).nextPretty(), 1100)
        XCTAssertEqual(CGFloat(1111).nextPretty(), 1200)
        XCTAssertEqual(CGFloat(1900).nextPretty(), 2000)
        XCTAssertEqual(CGFloat(1901).nextPretty(), 2000)

        XCTAssertEqual(
            TelegramCharts.Range<Int>(min: 0, max: 1).pretty(intervals: 0),
            TelegramCharts.Range<Int>(min: 0, max: 1)
        )

        XCTAssertEqual(
            TelegramCharts.Range<Int>(min: 0, max: 1).pretty(intervals: 1),
            TelegramCharts.Range<Int>(min: 0, max: 1)
        )

        XCTAssertEqual(
            TelegramCharts.Range<Int>(min: 0, max: 0).pretty(intervals: 2),
            TelegramCharts.Range<Int>(min: 0, max: 0)
        )
    }
}
