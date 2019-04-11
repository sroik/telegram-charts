//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarColumnRenderer {
    func render(
        values: [StackedColumnValue],
        range: Range<Int>,
        in rect: CGRect,
        in context: UIGraphicsRendererContext,
        minHeight: CGFloat = 0
    ) {
        let frames = StackedColumnValue.barFrames(
            of: values,
            in: rect,
            range: range,
            minHeight: minHeight
        )

        frames.enumerated().forEach { index, frame in
            let color = values[safe: index]?.color ?? UIColor.clear.cgColor
            context.cgContext.setFillColor(color)
            context.fill(frame.rounded())
        }
    }
}
