//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Array where Element: Arithmetical {
    var range: Range<Element> {
        return range(in: Range(min: 0, max: 1))
    }

    func range(in viewport: Range<CGFloat>) -> Range<Element> {
        guard
            let from = index(nearestTo: viewport.min),
            let to = index(nearestTo: viewport.max)
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
    func elements(in viewport: Range<CGFloat>) -> [Element] {
        guard
            let fromIndex = index(nearestTo: viewport.min),
            let toIndex = index(nearestTo: viewport.max)
        else {
            return []
        }

        return Array(self[fromIndex ... toIndex])
    }
}
