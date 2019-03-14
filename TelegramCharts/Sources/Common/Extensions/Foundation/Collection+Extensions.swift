//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Dictionary {
    func mapKeys<K: Hashable>(using block: (Key) -> K) -> [K: Value] {
        return [K: Value](uniqueKeysWithValues: map { key, value in
            (block(key), value)
        })
    }
}
