//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Chart {
    /* I don't know the logic, so I'll just leave hardcoded numbers */
    var minViewportSize: CGFloat {
        return viewportSizeToCover(days: expandable ? 30 : 0.5)
    }

    var minViewportShift: CGFloat {
        if expandable && percentage {
            return 1.0 / CGFloat(timestamps.count)
        }

        return 0
    }

    var preferredViewportSize: CGFloat {
        return expandable ? minViewportSize : viewportSizeToCover(days: 1)
    }

    func viewportSizeToCover(days: CGFloat) -> CGFloat {
        let size = days / CGFloat(self.days)
        return size.clamped(from: 0, to: 1)
    }

    func viewport(toCover day: Timestamp) -> Viewport {
        let viewportSize = viewportSizeToCover(days: 1)
        let nearestIndex = timestamps.indexOfNearest(to: day) ?? 0
        let min = CGFloat(nearestIndex) / CGFloat(timestamps.count)
        return Viewport(
            min: min.clamped(from: 0, to: 1 - viewportSize),
            size: viewportSize
        )
    }
}
