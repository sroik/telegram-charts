//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

typealias PieSlice = Range<CGFloat>

extension StackedColumn {
    typealias Slice = Range<CGFloat>

    static var empty: StackedColumn {
        return StackedColumn(index: 0, values: [])
    }

    static func columns(with chartColumns: [Column]) -> [StackedColumn] {
        let count = chartColumns.map { $0.values.count }.min() ?? 0
        let columns = (0 ..< count).map { index in
            StackedColumn(columns: chartColumns, at: index)
        }
        return columns
    }

    init(columns: [Column], at index: Index) {
        self.init(index: index, values: columns.map { column in
            StackedColumnValue(
                id: column.id,
                value: column.values[safe: index] ?? 0,
                color: column.cgColor,
                isEnabled: true
            )
        })
    }

    mutating func enable(ids: Set<String>) {
        values.transform { _, value in
            value.isEnabled = ids.contains(value.id)
        }
    }

    func stackedValue() -> Int {
        return values
            .lazy
            .filter { $0.isEnabled }
            .reduce(0) { $0 + $1.value }
    }

    func percents() -> [CGFloat] {
        let stackedValue = self.stackedValue()
        guard stackedValue > 0 else {
            return values.map { _ in 0 }
        }

        return values.map {
            $0.isEnabled ? CGFloat($0.value) / CGFloat(stackedValue) : 0
        }
    }

    func pieSlices() -> [PieSlice] {
        return slices(height: 2 * .pi)
    }

    func slices(height: CGFloat, minHeight: CGFloat = 0) -> [Slice] {
        let stackedValue = self.stackedValue()

        guard height > 0, stackedValue > 0 else {
            return values.map { _ in .zero }
        }

        var stackedHeight: CGFloat = 0
        var slices: [Slice] = []

        for value in values {
            let ratio = CGFloat(value.value) / CGFloat(stackedValue)
            let minValueHeight = value.value > 0 ? minHeight : 0
            let ratioHeight = max(height * ratio, minValueHeight)
            let valueHeight = value.isEnabled ? ratioHeight : 0

            slices.append(Slice(min: stackedHeight, size: valueHeight))
            stackedHeight += valueHeight
        }

        return slices
    }

    func percentagePoints(
        x: CGFloat = 0,
        height: CGFloat,
        minHeight: CGFloat = 0
    ) -> [CGPoint] {
        return slices(height: height, minHeight: minHeight).map { slice in
            CGPoint(x: x, y: height - slice.max)
        }
    }

    func barFrames(
        in rect: CGRect,
        maxValue: Int,
        minHeight: CGFloat = 0
    ) -> [CGRect] {
        let heightPortion = maxValue > 0 ? CGFloat(stackedValue()) / CGFloat(maxValue) : 0
        let filledHeight = heightPortion * rect.height

        return slices(height: filledHeight, minHeight: minHeight).map { slice in
            CGRect(
                x: rect.minX,
                y: rect.maxY - slice.max,
                width: rect.width,
                height: slice.size
            )
        }
    }
}
