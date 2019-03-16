//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CGFloat {
    static var layoutEpsilon: CGFloat {
        return 1e-2
    }

    static var pointsEpsilon: CGFloat {
        return 1.0
    }

    static var pixel: CGFloat {
        return 1.0 / UIScreen.main.scale
    }
}

extension CGPoint {
    func distance(to: CGPoint) -> CGFloat {
        let dx = x - to.x
        let dy = y - to.y
        return sqrt(dx * dx + dy * dy)
    }

    func isClose(to point: CGPoint, threshold: CGFloat) -> Bool {
        return distance(to: point) <= threshold
    }
}

extension CGRect {
    static var screen: CGRect {
        return UIScreen.main.bounds
    }

    var vertices: [CGPoint] {
        return [
            CGPoint(x: minX, y: minY),
            CGPoint(x: minX, y: maxY),
            CGPoint(x: maxX, y: maxY),
            CGPoint(x: maxX, y: minY)
        ]
    }

    func distance(to rect: CGRect) -> CGFloat {
        return zip(vertices, rect.vertices).reduce(0) { accumulator, next in
            accumulator + next.0.distance(to: next.1)
        }
    }
}

extension CGPath {
    static func between(points: [CGPoint]) -> CGPath {
        let path = CGMutablePath()
        path.addLines(between: points)
        return path
    }
}

extension UIEdgeInsets {
    var vertical: CGFloat {
        return top + bottom
    }

    init(repeated value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    init(top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }

    func inset(_ rect: CGRect) -> CGRect {
        return rect.inset(by: self)
    }
}

extension Array where Element == CGPoint {
    func dropClose(threshold: CGFloat) -> [CGPoint] {
        guard threshold > .ulpOfOne else {
            return self
        }

        var result: [CGPoint] = []

        forEach { point in
            if let last = result.last, last.isClose(to: point, threshold: threshold) {
                return
            }

            result.append(point)
        }

        return result
    }
}
