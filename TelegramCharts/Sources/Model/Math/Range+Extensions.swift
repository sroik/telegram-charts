//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

typealias Viewport = Range<CGFloat>

extension Range {
    static var zero: Range<T> {
        return Range(min: 0, max: 0)
    }

    static var zeroToOne: Range<CGFloat> {
        return Range<CGFloat>(min: 0, max: 1)
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

    func clamped(from: T, to: T) -> Range<T> {
        return Range(
            min: min.clamped(from: from, to: to),
            max: max.clamped(from: from, to: to)
        )
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
