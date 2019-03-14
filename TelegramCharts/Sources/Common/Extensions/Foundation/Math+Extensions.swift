//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

typealias Index = Int

extension Comparable {
    func clamped(from: Self, to: Self) -> Self {
        assertWrapper(from <= to, "invalid clamp range", "`to` should be greater than `from`")
        return min(max(self, from), to)
    }

    func compare(with value: Self) -> ComparisonResult {
        if self > value {
            return .orderedDescending
        }

        if self < value {
            return .orderedAscending
        }

        return .orderedSame
    }
}

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }

    var isPowerOfTwo: Bool {
        return self > 0 && nonzeroBitCount == 1
    }

    var nearestPowerOfTwo: Int? {
        guard self > 0 else {
            return nil
        }

        for i in stride(from: self, to: 0, by: -1) where i.isPowerOfTwo {
            return i
        }

        return nil
    }
}
