//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

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

    func adjustedRange(of columns: [Column], in viewport: Viewport) -> Range<Int> {
        let ranges = columns.map { $0.range(in: viewport) }
        let range = stacked ? ranges.stacked() : ranges.union()
        return range
    }

    func adjustedRange(of column: Column, in viewport: Viewport) -> Range<Int> {
        return column.range(in: viewport)
    }

    func timePeriod(in viewport: Viewport) -> Range<Date> {
        let min = timestamps.element(nearestTo: viewport.min, strategy: .floor) ?? 0
        let max = timestamps.element(nearestTo: viewport.max, strategy: .ceil) ?? 0
        return Range(
            min: Date(timestamp: min),
            max: Date(timestamp: max)
        )
    }
}
