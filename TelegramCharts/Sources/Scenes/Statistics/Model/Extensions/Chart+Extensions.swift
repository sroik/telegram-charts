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

    func columns(with ids: [String]) -> [Column] {
        return ids.compactMap(columns(with:))
    }

    func columns(with id: String) -> Column? {
        return columns.first { $0.id == id }
    }

    var minDate: Date {
        return Date(timestamp: timestamps.first ?? 0)
    }

    var maxDate: Date {
        return Date(timestamp: timestamps.last ?? 0)
    }

    var days: Int {
        return Int(ceil(maxDate.timeIntervalSince(minDate) / .day))
    }
}
