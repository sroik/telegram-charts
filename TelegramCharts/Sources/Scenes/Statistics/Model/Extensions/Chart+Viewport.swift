//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Chart {
    func timePeriod(in viewport: Viewport) -> Range<Date> {
        let min = timestamps.element(nearestTo: viewport.min, rule: .down) ?? 0
        let max = timestamps.element(nearestTo: viewport.max, rule: .up) ?? 0
        return Range(
            min: Date(timestamp: min),
            max: Date(timestamp: max)
        )
    }

    /* I don't know the logic, so I'll just leave hardcoded numbers */
    var minViewportSize: CGFloat {
        return viewportSizeToCover(days: expandable ? 30 : 0.5)
    }

    var preferredViewportSize: CGFloat {
        return expandable ? minViewportSize : viewportSizeToCover(days: 1)
    }

    func viewportSizeToCover(days: CGFloat) -> CGFloat {
        let size = days / CGFloat(self.days)
        return size.clamped(from: 0, to: 1)
    }
}
