//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

enum RoundStrategy {
    case round
    case ceil
    case floor

    func round(_ value: CGFloat) -> CGFloat {
        switch self {
        case .ceil: return value.ceiled()
        case .floor: return value.floored()
        case .round: return value.rounded()
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Index == Int {
    func index(nearestTo zeroToOnePosition: CGFloat, strategy: RoundStrategy) -> Int? {
        guard !isEmpty else {
            return nil
        }

        let floatingIndex = CGFloat(count) * zeroToOnePosition - 1
        let index = Int(strategy.round(floatingIndex))
        let clampedIndex = index.clamped(from: 0, to: count - 1)
        return clampedIndex
    }

    func element(
        nearestTo zeroToOnePosition: CGFloat,
        strategy: RoundStrategy
    ) -> Iterator.Element? {
        guard let index = index(nearestTo: zeroToOnePosition, strategy: strategy) else {
            return nil
        }

        return self[safe: index]
    }
}

extension Dictionary {
    func mapKeys<K: Hashable>(using block: (Key) -> K) -> [K: Value] {
        return [K: Value](uniqueKeysWithValues: map { key, value in
            (block(key), value)
        })
    }
}
