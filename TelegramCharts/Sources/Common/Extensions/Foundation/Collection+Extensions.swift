//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Index == Int {
    func index(
        nearestTo zeroToOnePosition: CGFloat,
        rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero
    ) -> Int? {
        guard !isEmpty else {
            return nil
        }

        let floatingIndex = CGFloat(count) * zeroToOnePosition - 1
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

extension Array {
    mutating func transform(using block: (Int, inout Element) -> Void) {
        indices.forEach { idx in
            block(idx, &self[idx])
        }
    }
}
