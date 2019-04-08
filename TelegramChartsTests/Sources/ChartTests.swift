//
//  Copyright © 2019 sroik. All rights reserved.
//

@testable import TelegramCharts
import UIKit
import XCTest

class ChartTests: XCTestCase {
    func testCorrectParsing() throws {
        let url = try Bundle.test.url(forResource: "test_chart", withExtension: "json").get()
        let chart = try Chart.chart(id: "id", at: url)

        let expected = Chart(
            id: "id",
            title: "title",
            columns: [
                Column(
                    id: "x",
                    type: .timestamps,
                    name: nil,
                    color: nil,
                    values: [
                        1_542_412_800_000,
                        1_542_499_200_000,
                        1_542_585_600_000,
                        1_542_672_000_000,
                        1_542_758_400_000
                    ]
                ),
                Column(
                    id: "y0",
                    type: .line,
                    name: "#0",
                    color: "#3DC23F",
                    values: [37, 20, 32, 39, 32]
                ),
                Column(
                    id: "y1",
                    type: .line,
                    name: "#1",
                    color: "#F34C44",
                    values: [22, 12, 30, 40, 33]
                )
            ],
            percentage: true,
            stacked: true,
            yScaled: true
        )

        XCTAssertEqual(chart, expected)
    }
}
