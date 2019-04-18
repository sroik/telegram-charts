//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CGFloat {
    static var percent: CGFloat = 1 / 100

    /*
     * I've used this algorithm to round percents
     * https://en.wikipedia.org/wiki/Largest_remainder_method
     */
    static func rounded(percents: [CGFloat]) -> [CGFloat] {
        var flooredSortedByRemainder = percents
            .enumerated()
            .sorted { $0.element.percentFloorRemainder > $1.element.percentFloorRemainder }
            .map { (index: $0.offset, value: $0.element.percentFloor) }

        let percentsSum = percents.reduce(0, +)
        let flooredSum = percents.map { $0.percentFloor }.reduce(0, +)
        let diff = percentsSum - flooredSum
        let diffedCount = Int((diff / percent).rounded())

        flooredSortedByRemainder.transform { index, arg in
            if index < diffedCount {
                arg.value += CGFloat.percent
            }
        }

        let roundedPercents = flooredSortedByRemainder
            .sorted { $0.index < $1.index }
            .map { $0.value }

        return roundedPercents
    }

    var percentFloorRemainder: CGFloat {
        return self - percentFloor
    }

    var percentFloor: CGFloat {
        return floor(self / CGFloat.percent) * CGFloat.percent
    }
}
