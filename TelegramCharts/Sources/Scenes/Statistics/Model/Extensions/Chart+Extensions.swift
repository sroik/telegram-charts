//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

typealias Timestamp = Int

extension Chart {
    var timestamps: [Timestamp] {
        guard let column = timestampsColumn else {
            assertionFailureWrapper("chart has no timestamps column")
            return []
        }

        return column.values
    }

    var timestampsColumn: Column? {
        return columns.first { $0.type.isTimestamps }
    }

    var drawableColumns: [Column] {
        return columns.filter { $0.type.isDrawable }
    }

    var columnsType: ColumnType {
        guard let drawableColumn = drawableColumns.first else {
            assertionFailureWrapper("no columns found")
            return .line
        }

        return drawableColumn.type
    }

    var minDate: Date {
        return Date(timestamp: timestamps.first ?? 0)
    }

    var maxDate: Date {
        return Date(timestamp: timestamps.last ?? 0)
    }

    var days: Int {
        return Int(maxDate.timeIntervalSince(minDate) / .day)
    }

    /* I don't know the logic, so I'll just leave hardcoded numbers */
    var minViewportSize: CGFloat {
        let minDays = expandable ? 30 : 1
        return CGFloat(minDays) / CGFloat(days)
    }

    var maxViewportSize: CGFloat {
        return 1.0
    }

    func timePeriod(in viewport: Viewport) -> Range<Date> {
        let min = timestamps.element(nearestTo: viewport.min, strategy: .floor) ?? 0
        let max = timestamps.element(nearestTo: viewport.max, strategy: .ceil) ?? 0
        return Range(
            min: Date(timestamp: min),
            max: Date(timestamp: max)
        )
    }

    func adjustedRange(of columns: [Column], in viewport: Viewport = .zeroToOne) -> Range<Int> {
        let range = stacked ?
            stackedRange(of: columns, in: viewport) :
            unitedRange(of: columns, in: viewport)

        return range
    }

    func adjustedRange(of column: Column, in viewport: Viewport = .zeroToOne) -> Range<Int> {
        return column.range(in: viewport)
    }

    private func unitedRange(of columns: [Column], in viewport: Viewport) -> Range<Int> {
        return columns
            .map { $0.range(in: viewport) }
            .union()
    }

    func stackedRange(of columns: [Column], in viewport: Viewport) -> Range<Int> {
        let values = stackedValues(of: columns, in: viewport)
        return Range(min: 0, max: values.max() ?? 0)
    }

    func stackedValues(of columns: [Column], in viewport: Viewport) -> [Int] {
        guard var values = columns.first?.values(in: viewport) else {
            return []
        }

        columns.dropFirst().forEach { column in
            let columnValues = column.values(in: viewport)
            values = zip(values, columnValues).map { $0 + $1 }
        }

        return values
    }
}
