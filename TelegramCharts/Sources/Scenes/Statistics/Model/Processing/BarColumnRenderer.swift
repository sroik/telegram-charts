//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class BarColumnRenderer {
    func render(
        values: [BarColumnValue],
        range: Range<Int>,
        in rect: CGRect,
        in context: UIGraphicsRendererContext
    ) {
        let frames = BarColumnValue.frames(of: values, in: rect, range: range)
        frames.enumerated().forEach { index, frame in
            let color = values[safe: index]?.color ?? UIColor.clear.cgColor
            context.cgContext.setFillColor(color)
            context.fill(frame.rounded())
        }
    }
}
