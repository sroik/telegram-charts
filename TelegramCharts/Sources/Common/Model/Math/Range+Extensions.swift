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

extension Range where T: Arithmetical {
    static var zero: Range<T> {
        return Range(min: 0, max: 0)
    }

    static var zeroToOne: Viewport {
        return Viewport(min: 0, max: 1)
    }

    var isEmpty: Bool {
        return min == max
    }

    var size: T {
        return max - min
    }

    var mid: T {
        return (max + min) / T(2)
    }

    init(mid: T, size: T) {
        let halfSize = Swift.max(0, size) / T(2)
        self.init(
            min: mid - halfSize,
            max: mid + halfSize
        )
    }

    init(min: T, size: T) {
        self.init(
            min: min,
            max: min + size
        )
    }

    init(max: T, size: T) {
        self.init(
            min: max - size,
            max: max
        )
    }

    func union(with range: Range<T>) -> Range<T> {
        return Range(
            min: Swift.min(min, range.min),
            max: Swift.max(max, range.max)
        )
    }

    func clamped(from: T, to: T) -> Range<T> {
        return Range(
            min: min.clamped(from: from, to: to),
            max: max.clamped(from: from, to: to)
        )
    }

    func limited(from: T, to: T) -> Range<T> {
        guard size < to - from else {
            return Range(min: from, max: to)
        }

        if from > min {
            return Range(min: from, size: size)
        }

        if to < max {
            return Range(max: to, size: size)
        }

        return self
    }
}

extension Range where T == Int {
    func scaled(by: CGFloat, from edge: RangeEdge) -> Range<Int> {
        let size = Int(CGFloat(self.size) * by)
        switch edge {
        case .center: return Range(mid: mid, size: size)
        case .top: return Range(min: max - size, max: max)
        case .bottom: return Range(min: min, max: min + size)
        }
    }

    func value(at zeroToOnePosition: CGFloat) -> Int {
        let offset = Int(CGFloat(size) * zeroToOnePosition)
        let value = (min + offset).clamped(from: min, to: max)
        return value
    }
}

extension Int: DoubleConvertible, Dividable {}
extension CGFloat: DoubleConvertible, Dividable {}
extension Double: DoubleConvertible, Dividable {}
