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
        var frames: [CGRect] = []
        var maxY = rect.maxY

        for value in values {
            let height = value.height(in: rect, range: range)
            let valueRect = CGRect(
                x: rect.minX,
                maxY: maxY,
                width: rect.width,
                height: height
            ).inflated()

            frames.append(valueRect)
            maxY -= height
        }

        return frames
    }

    func height(in rect: CGRect, range: Range<Int>) -> CGFloat {
        guard !range.isEmpty else {
            return 0
        }

        let ratio = CGFloat(value) / CGFloat(range.size)
        let ratioHeight = rect.height * max(ratio, 0.025)
        return isEnabled ? ratioHeight : 0
    }
}
