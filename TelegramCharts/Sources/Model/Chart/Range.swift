//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

typealias Arithmetical = Numeric & Comparable

struct Range<T: Arithmetical>: Equatable {
    var min: T
    var max: T

    init(min: T, max: T) {
        self.min = Swift.min(min, max)
        self.max = Swift.max(min, max)
    }
}

extension Range {
    var size: T {
        return max - min
    }
}

extension Array where Element: Arithmetical {
    var range: Range<Element> {
        var range: Range<Element> = Range(min: 0, max: 0)
        forEach { element in
            range.min = Swift.min(range.min, element)
            range.max = Swift.max(range.max, element)
        }
        return range
    }
}
