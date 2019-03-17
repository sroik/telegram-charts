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

    func floored() -> CGFloat {
        return floor(self)
    }

    func ceiled() -> CGFloat {
        return ceil(self)
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

    var diagonal: CGFloat {
        return sqrt(width * width + height * height)
    }

    init(midX: CGFloat, y: CGFloat = 0, size: CGSize) {
        self.init(midX: midX, y: y, width: size.width, height: size.height)
    }

    init(midX: CGFloat, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        self.init(
            x: midX - width / 2,
            y: y,
            width: width,
            height: height
        )
    }

    func distance(to rect: CGRect) -> CGFloat {
        return zip(vertices, rect.vertices).reduce(0) { accumulator, next in
            accumulator + next.0.distance(to: next.1)
        }
    }

    func with(width: CGFloat? = nil, height: CGFloat? = nil) -> CGRect {
        return CGRect(
            x: minX,
            y: minY,
            width: width ?? self.width,
            height: height ?? self.height
        )
    }

    func limited(with rect: CGRect) -> CGRect {
        var result = self

        if maxY > rect.maxY {
            result.origin.y += rect.maxY - maxY
        }

        if minY < rect.minY {
            result.origin.y = rect.minY
        }

        if maxX > rect.maxX {
            result.origin.x += rect.maxX - maxX
        }

        if minX < rect.minX {
            result.origin.x = rect.minX
        }

        return result
    }
}

extension CGPath {
    static func between(points: [CGPoint]) -> CGPath {
        let path = CGMutablePath()
        path.addLines(between: points)
        return path
    }

    static func circle(center: CGPoint = .zero, radius: CGFloat) -> CGPath {
        return CGPath(ellipseIn: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: 2 * radius,
            height: 2 * radius
        ), transform: nil)
    }
}

extension UIEdgeInsets {
    var vertical: CGFloat {
        return top + bottom
    }

    var horizontal: CGFloat {
        return left + right
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
