//
//  Copyright © 2019 sroik. All rights reserved.
//

@testable import TelegramCharts
import XCTest

class PercentsTests: XCTestCase {
    func testPercentsRounding() {
        (0 ..< 100).forEach {
            let values = StackedColumnValue.random(count: $0)
            let column = StackedColumn(index: 0, values: values)
            let percents = column.percents()
            check(
                percents: percents,
                roundedPercents: CGFloat.rounded(percents: percents)
            )
        }
    }

    private func check(percents: [CGFloat], roundedPercents: [CGFloat]) {
        XCTAssertEqual(percents.count, roundedPercents.count)
        zip(percents, roundedPercents).forEach { p, rp in
            let diff = abs(rp - p)
            XCTAssertTrue(diff < CGFloat.percent)
        }
    }
}

private extension StackedColumnValue {
    static func random(count: Int) -> [StackedColumnValue] {
        return [Int].random(count: count).map {
            StackedColumnValue(id: "", value: $0)
        }
    }
}
