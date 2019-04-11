//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension StackedColumnValue {
    static var empty: StackedColumnValue {
        return StackedColumnValue(id: "", value: 0)
    }

    static func values(of columns: [Column], at index: Index) -> [StackedColumnValue] {
        return columns.map { column in
            StackedColumnValue(
                id: column.id,
                value: column.values[safe: index] ?? 0,
                color: column.cgColor,
                isEnabled: true
            )
        }
    }

    static func barFrames(
        of values: [StackedColumnValue],
        in rect: CGRect,
        range: Range<Int>,
        minHeight: CGFloat = 0
    ) -> [CGRect] {
        guard !range.isEmpty else {
            return values.map { _ in CGRect.zero }
        }

        var frames: [CGRect] = []
        var stackedHeight: CGFloat = 0

        for value in values {
            let ratio = CGFloat(value.value) / CGFloat(range.size)
            let ratioHeight = max(rect.height * ratio, minHeight)
            let height = value.isEnabled ? ratioHeight : 0

            let valueRect = CGRect(
                x: rect.minX,
                maxY: rect.maxY - stackedHeight,
                width: rect.width,
                height: height
            )

            frames.append(valueRect)
            stackedHeight += height
        }

        return frames
    }
}
