//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarColumnRenderer {
    func render(
        column: StackedColumn,
        maxValue: Int,
        in rect: CGRect,
        in context: UIGraphicsRendererContext,
        minHeight: CGFloat = 0
    ) {
        let frames = column.barFrames(
            in: rect,
            maxValue: maxValue,
            minHeight: minHeight
        )

        frames.enumerated().forEach { index, frame in
            let color = column.values[safe: index]?.color ?? UIColor.clear.cgColor
            context.cgContext.setFillColor(color)
            context.fill(frame.rounded())
        }
    }
}
