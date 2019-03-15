//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

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
