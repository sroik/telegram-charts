//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

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

extension Range where T == Int {
    func scaled(by: CGFloat) -> Range<Int> {
        return Range(mid: mid, size: Int(CGFloat(size) * by))
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
