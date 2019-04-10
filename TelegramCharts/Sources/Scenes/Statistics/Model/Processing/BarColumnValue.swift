//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct BarColumnValue: Hashable {
    var id: String
    var value: Int
    var color: CGColor?
    var isEnabled: Bool
}

extension BarColumnValue {
    static var empty: BarColumnValue {
        return BarColumnValue(id: "", value: 0, color: nil, isEnabled: true)
    }

    static func values(of columns: [Column], at index: Index) -> [BarColumnValue] {
        return columns.map { column in
            BarColumnValue(
                id: column.id,
                value: column.values[safe: index] ?? 0,
                color: column.cgColor,
                isEnabled: true
            )
        }
    }

    static func frames(
        of values: [BarColumnValue],
        in rect: CGRect,
        range: Range<Int>
    ) -> [CGRect] {
        guard !range.isEmpty else {
            return values.map { _ in CGRect.zero }
        }

        var frames: [CGRect] = []
        var maxY = rect.maxY

        for value in values {
            let ratio = CGFloat(value.value) / CGFloat(range.size)
            let ratioHeight = rect.height * ratio
            let height = value.isEnabled ? ratioHeight : 0

            let valueRect = CGRect(
                x: rect.minX,
                maxY: maxY,
                width: rect.width,
                height: height
            )

            frames.append(valueRect)
            maxY -= height
        }

        return frames
    }
}
