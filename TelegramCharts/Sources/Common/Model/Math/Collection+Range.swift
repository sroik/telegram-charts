//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Array where Element: Arithmetical {
    var range: Range<Element> {
        return range(in: Range(min: 0, max: 1))
    }

    func range(in viewport: Viewport) -> Range<Element> {
        let elements = self.elements(in: viewport)

        guard
            var min: Element = elements.first,
            var max: Element = elements.first
        else {
            return .zero
        }

        elements.forEach { element in
            min = Swift.min(min, element)
            max = Swift.max(max, element)
        }

        return Range<Element>(min: min, max: max)
    }
}

extension Array {
    func elements(in viewport: Viewport) -> ArraySlice<Element> {
        guard
            let fromIndex = index(nearestTo: viewport.min, rule: .down),
            let toIndex = index(nearestTo: viewport.max, rule: .up)
        else {
            return []
        }

        return self[fromIndex ... toIndex]
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
