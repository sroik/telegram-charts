//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Collection where Index == Int {
    subscript(safe index: Int) -> Element? {
        return index < 0 || index >= count ? nil : self[index]
    }

    func index(
        nearestTo zeroToOnePosition: CGFloat,
        rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero
    ) -> Int? {
        guard !isEmpty else {
            return nil
        }

        let floatingIndex = CGFloat(count) * zeroToOnePosition - 0.5
        let index = Int(floatingIndex.rounded(rule))
        let clampedIndex = index.clamped(from: 0, to: count - 1)
        return clampedIndex
    }

    func element(
        nearestTo zeroToOnePosition: CGFloat,
        rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero
    ) -> Iterator.Element? {
        guard let index = index(nearestTo: zeroToOnePosition, rule: rule) else {
            return nil
        }

        return self[safe: index]
    }
}

extension Array where Element == Int {
    func indexOfNearest(to element: Element) -> Int? {
        guard count > 0 else {
            return nil
        }

        var nearestIndex = 0
        var nearestDistance: Int = .max

        enumerated().forEach { index, e in
            let distance: Int = abs(element - e)
            if distance < nearestDistance {
                nearestDistance = distance
                nearestIndex = index
            }
        }

        return nearestIndex
    }
}

extension Array {
    mutating func transform(using block: (Int, inout Element) -> Void) {
        indices.forEach { idx in
            block(idx, &self[idx])
        }
    }
}
