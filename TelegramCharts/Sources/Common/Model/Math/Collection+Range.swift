//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Array where Element: Arithmetical {
    var range: Range<Element> {
        return range(in: Range(min: 0, max: 1))
    }

    func range(in viewport: Viewport) -> Range<Element> {
        guard
            let from = index(nearestTo: viewport.min, strategy: .floor),
            let to = index(nearestTo: viewport.max, strategy: .ceil)
        else {
            return .zero
        }

        var min: Element = self[from]
        var max: Element = self[from]

        self[from ... to].forEach { element in
            min = Swift.min(min, element)
            max = Swift.max(max, element)
        }

        return Range<Element>(min: min, max: max)
    }
}

extension Collection where Index == Int {
    func elements(in viewport: Viewport) -> [Element] {
        guard
            let fromIndex = index(nearestTo: viewport.min, strategy: .floor),
            let toIndex = index(nearestTo: viewport.max, strategy: .ceil)
        else {
            return []
        }

        return Array(self[fromIndex ... toIndex])
    }
}

extension Array where Element == Range<Int> {
    func union() -> Range<Int> {
        guard let first = first else {
            return .zero
        }

        return dropFirst().reduce(first) { result, range in
            result.union(with: range)
        }
    }
}
