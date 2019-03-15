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
    func element(nearestTo zeroToOnePosition: CGFloat) -> Iterator.Element? {
        guard !isEmpty else {
            return nil
        }

        let index = Int(CGFloat(count) * zeroToOnePosition) - 1
        let clampedIndex = index.clamped(from: 0, to: count - 1)
        return self[safe: clampedIndex]
    }
}

extension Dictionary {
    func mapKeys<K: Hashable>(using block: (Key) -> K) -> [K: Value] {
        return [K: Value](uniqueKeysWithValues: map { key, value in
            (block(key), value)
        })
    }
}
