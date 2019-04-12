//
//  Copyright © 2019 sroik. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    static func random(count: Int, min: Int = 1, max: Int = 100) -> [Int] {
        return (0 ..< count).map { _ in
            Int.random(in: min ... max)
        }
    }
}
