//
//  Copyright © 2019 sroik. All rights reserved.
//

@testable import TelegramCharts
import XCTest

class StackedColumnTests: XCTestCase {
    func testEmptyColumnSlices() {
        let column = StackedColumn(intValues: [])
        XCTAssertEqual(column.slices(height: 10), [])
    }

    func testZeroValuesSlices() {
        let column = StackedColumn(intValues: [0, 0])
        XCTAssertEqual(column.slices(height: 10), [
            StackedColumn.Slice(min: 0, max: 0),
            StackedColumn.Slice(min: 0, max: 0)
        ])
    }

    func testSlices() {
        let column = StackedColumn(intValues: [15, 35, 50])
        XCTAssertEqual(column.slices(height: 10), [
            StackedColumn.Slice(min: 0, max: 1.5),
            StackedColumn.Slice(min: 1.5, max: 5.0),
            StackedColumn.Slice(min: 5.0, max: 10)
        ])
    }

    func testEmptyColumnPercentagePoints() {
        let column = StackedColumn(intValues: [])
        XCTAssertEqual(column.percentagePoints(height: 0), [])
    }

    func testZeroValuesPercentagePoints() {
        let column = StackedColumn(intValues: [0, 0])
        XCTAssertEqual(column.percentagePoints(height: 10), [
            CGPoint(x: 0, y: 10),
            CGPoint(x: 0, y: 10)
        ])
    }

    func testPercentagePoints() {
        let column = StackedColumn(intValues: [15, 35, 50])
        XCTAssertEqual(column.percentagePoints(x: 1, height: 10), [
            CGPoint(x: 1, y: 8.5),
            CGPoint(x: 1, y: 5),
            CGPoint(x: 1, y: 0)
        ])
    }

    func testEmptyColumnBarFrames() {
        let column = StackedColumn(intValues: [])
        XCTAssertEqual(column.barFrames(in: .zero, maxValue: 10), [])
    }

    func testZeroValuesBarFrames() {
        let column = StackedColumn(intValues: [0, 0])
        let rect = CGRect(x: 1, y: 1, width: 5, height: 10)
        let expected = CGRect(x: 1, y: 11, width: 5, height: 0)
        XCTAssertEqual(column.barFrames(in: rect, maxValue: 5), [expected, expected])
    }

    func testZeroMaxValueBarFrames() {
        let column = StackedColumn(intValues: [50, 50])
        let rect = CGRect(x: 1, y: 1, width: 5, height: 10)
        let expected = CGRect(x: 1, y: 11, width: 5, height: 0)
        XCTAssertEqual(column.barFrames(in: rect, maxValue: 0), [expected, expected])
    }

    func testBarFrames() {
        let column = StackedColumn(intValues: [15, 35, 50])
        let rect = CGRect(x: 1, y: 1, width: 5, height: 20)
        XCTAssertEqual(column.barFrames(in: rect, maxValue: 200), [
            CGRect(x: 1, y: 21 - 1.5, width: 5, height: 1.5),
            CGRect(x: 1, y: 21 - 5.0, width: 5, height: 3.5),
            CGRect(x: 1, y: 21 - 10.0, width: 5, height: 5.0)
        ])
    }
}

extension StackedColumn {
    init(intValues: [Int]) {
        self.init(values: intValues.map { StackedColumnValue(id: "", value: $0) })
    }
}
