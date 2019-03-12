//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CGFloat {
    static var pixel: CGFloat {
        return 1.0 / UIScreen.main.scale
    }
}

extension CGPath {
    static func between(points: [CGPoint]) -> CGPath {
        let path = CGMutablePath()
        path.addLines(between: points)
        return path
    }
}
