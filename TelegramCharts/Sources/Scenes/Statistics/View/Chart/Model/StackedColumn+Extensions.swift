//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension StackedColumn {
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

    var stackedValue: Int {
        return values
            .lazy
            .filter { $0.isEnabled }
            .map { $0.value }
            .reduce(0, +)
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

    func percentagePoints(
        x: CGFloat,
        height: CGFloat,
        minHeight: CGFloat = 0
    ) -> [CGPoint] {
        guard height > 0, self.stackedValue > 0 else {
            return values.map { _ in CGPoint.zero }
        }

        let stackedValue = self.stackedValue
        var stackedHeight: CGFloat = 0
        var points: [CGPoint] = []

        for value in values {
            let ratio = CGFloat(value.value) / CGFloat(stackedValue)
            let valueHeight = max(height * ratio, minHeight)
            stackedHeight += value.isEnabled ? valueHeight : 0
            points.append(CGPoint(x: x, y: height - stackedHeight))
        }

        return points
    }

    func barFrames(
        in rect: CGRect,
        maxValue: Int,
        minHeight: CGFloat = 0
    ) -> [CGRect] {
        guard maxValue > 0, stackedValue > 0 else {
            return values.map { _ in CGRect.zero }
        }

        let heightPortion = CGFloat(stackedValue) / CGFloat(maxValue)
        let filledHeight = heightPortion * rect.height
        let minY = rect.maxY - filledHeight

        let origins = percentagePoints(
            x: rect.minX,
            height: filledHeight,
            minHeight: minHeight
        )

        var frames: [CGRect] = []
        var previousOriginY = filledHeight

        for origin in origins {
            let height = previousOriginY - origin.y
            let frame = CGRect(
                x: origin.x,
                y: minY + origin.y,
                width: rect.width,
                height: height
            )

            previousOriginY = origin.y
            frames.append(frame)
        }

        return frames
    }
}
