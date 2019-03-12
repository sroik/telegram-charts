//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

typealias Arithmetical = Numeric & Comparable

struct Range<T: Arithmetical>: Equatable {
    let min: T
    let max: T

    init(min: T, max: T) {
        self.min = Swift.min(min, max)
        self.max = Swift.max(min, max)
    }
}

extension Range {
    static var zero: Range<T> {
        return Range(min: 0, max: 0)
    }

    var size: T {
        return max - min
    }

    func union(with range: Range<T>) -> Range<T> {
        return Range(
            min: Swift.min(min, range.min),
            max: Swift.max(max, range.max)
        )
    }
}

extension Array where Element: Arithmetical {
    var range: Range<Element> {
        var min: Element = 0
        var max: Element = 0

        forEach { element in
            min = Swift.min(min, element)
            max = Swift.max(max, element)
        }

        return Range<Element>(min: min, max: max)
    }
}
