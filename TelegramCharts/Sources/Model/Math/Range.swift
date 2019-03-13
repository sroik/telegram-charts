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

extension Range {
    static var zero: Range<T> {
        return Range(min: 0, max: 0)
    }

    var size: T {
        return max - min
    }

    var mid: T {
        return (max + min) / T(2)
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
        guard let first = first else {
            return .zero
        }

        var min: Element = first
        var max: Element = first

        dropFirst().forEach { element in
            min = Swift.min(min, element)
            max = Swift.max(max, element)
        }

        return Range<Element>(min: min, max: max)
    }
}

extension Int: DoubleConvertible, Dividable {}
extension CGFloat: DoubleConvertible, Dividable {}
extension Double: DoubleConvertible, Dividable {}
