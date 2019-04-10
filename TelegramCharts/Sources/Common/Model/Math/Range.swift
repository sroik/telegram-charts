//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

struct Range<T: Comparable>: Equatable {
    let min: T
    let max: T

    init(min: T, max: T) {
        self.min = Swift.min(min, max)
        self.max = Swift.max(min, max)
    }
}

enum RangeEdge {
    case center
    case top
    case bottom
}
