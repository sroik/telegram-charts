//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Chart {
    var preferredGridIntervals: CGFloat {
        return 5.4
    }

    func range(of columns: [Column], in viewport: Viewport = .zeroToOne) -> Range<Int> {
        let range = stacked ?
            stackedRange(of: columns, in: viewport) :
            unitedRange(of: columns, in: viewport)

        return range.pretty(intervals: preferredGridIntervals)
    }

    func range(of column: Column, in viewport: Viewport = .zeroToOne) -> Range<Int> {
        return column
            .range(in: viewport)
            .pretty(intervals: preferredGridIntervals)
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
