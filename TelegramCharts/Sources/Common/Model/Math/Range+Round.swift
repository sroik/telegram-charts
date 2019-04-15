//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Range where T == Int {
    func pretty(intervals: CGFloat) -> Range<Int> {
        guard intervals > .ulpOfOne, size > 0 else {
            return self
        }

        let prettyMin = self.prettyMin(intervals: intervals)
        let size = CGFloat(self.max) - prettyMin
        let spacing = (size / intervals).nextPretty()
        let prettyMax = ceil(prettyMin + intervals * spacing)

        return Range(
            min: Int(prettyMin),
            max: Int(prettyMax)
        )
    }

    func prettyMin(intervals: CGFloat) -> CGFloat {
        let spacing = (CGFloat(size) / intervals).nextPretty()
        let prettyMin = floor(CGFloat(min) / spacing) * spacing
        return prettyMin
    }
}

extension CGFloat {
    var exponent: CGFloat {
        return floor(log10(self))
    }

    var exponentDegree: CGFloat {
        return pow(10, exponent)
    }

    func nextPretty() -> CGFloat {
        if abs(self) < 10 {
            return prettyCeil()
        }

        let degree = exponentDegree
        let base = floor(self / degree) * degree
        let remainder = (self - base)

        if abs(self) < 100 {
            return base + remainder.prettyCeil()
        }

        let remainderDegree = remainder.exponentDegree
        let degreeRatio = degree / remainderDegree
        if degreeRatio < 11 {
            return base + remainder.prettyCeil()
        }

        return base + degree / 10
    }

    func prettyCeil() -> CGFloat {
        let exponent = self.exponent
        let fraction = self / pow(10, exponent)
        let prettyFraction: CGFloat

        if fraction <= 1 {
            prettyFraction = 1
        } else if fraction <= 2 {
            prettyFraction = 2
        } else if fraction <= 5 {
            prettyFraction = 5
        } else {
            prettyFraction = 10
        }

        return prettyFraction * pow(10, exponent)
    }
}
