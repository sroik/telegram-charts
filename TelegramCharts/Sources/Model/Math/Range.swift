//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol DoubleConvertible {
    init(_ value: Double)
}

protocol Dividable {
    static func / (lhs: Self, rhs: Self) -> Self
}

typealias Arithmetical = Numeric & Comparable & DoubleConvertible & Dividable

struct Range<T: Arithmetical>: Equatable {
    let min: T
    let max: T

    init(min: T, max: T) {
        self.min = Swift.min(min, max)
        self.max = Swift.max(min, max)
    }

    init(mid: T, size: T) {
        let halfSize = Swift.max(0, size) / T(2)
        self.min = mid - halfSize
        self.max = mid + halfSize
    }
}
