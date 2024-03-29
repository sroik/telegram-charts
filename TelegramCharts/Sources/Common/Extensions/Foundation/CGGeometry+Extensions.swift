//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CGFloat {
    static var layoutEpsilon: CGFloat {
        return 1e-2
    }

    static var pointsEpsilon: CGFloat {
        return 1e-1
    }

    static var pixel: CGFloat {
        return 1.0 / UIScreen.main.scale
    }

    var floatingSign: CGFloat {
        return self > 0 ? 1 : -1
    }
}

extension CGPoint {
    static func - (l: CGPoint, r: CGPoint) -> CGPoint {
        return CGPoint(x: l.x - r.x, y: l.y - r.y)
    }

    func distance(to: CGPoint) -> CGFloat {
        let dx = x - to.x
        let dy = y - to.y
        return sqrt(dx * dx + dy * dy)
    }

    func isClose(to point: CGPoint, threshold: CGFloat = .pointsEpsilon) -> Bool {
        return distance(to: point) <= threshold
    }
}

extension CGSize {
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }

    func isClose(to size: CGSize, threshold: CGFloat = .layoutEpsilon) -> Bool {
        let widthDelta = abs(width - size.width)
        let heightDelta = abs(height - size.height)
        return (widthDelta + heightDelta) < threshold
    }
}

extension CGRect {
    static var screen: CGRect {
        return UIScreen.main.bounds
    }

    var minSide: CGFloat {
        return min(size.width, size.height)
    }

    var maxSide: CGFloat {
        return max(size.width, size.height)
    }

    var vertices: [CGPoint] {
        return [
            CGPoint(x: minX, y: minY),
            CGPoint(x: minX, y: maxY),
            CGPoint(x: maxX, y: maxY),
            CGPoint(x: maxX, y: minY)
        ]
    }

    var originless: CGRect {
        return CGRect(origin: .zero, size: size)
    }

    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }

    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    var diagonal: CGFloat {
        return sqrt(width * width + height * height)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }

    init(x: CGFloat, y: CGFloat = 0, size: CGSize) {
        self.init(x: x, y: y, width: size.width, height: size.height)
    }

    init(x: CGFloat = 0, maxY: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        self.init(x: x, y: maxY - height, width: width, height: height)
    }

    init(maxX: CGFloat, y: CGFloat = 0, size: CGSize) {
        self.init(maxX: maxX, y: y, width: size.width, height: size.height)
    }

    init(maxX: CGFloat, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        self.init(x: maxX - width, y: y, width: width, height: height)
    }

    init(x: CGFloat, y: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(x: x, y: y, width: maxX - x, height: maxY - y)
    }

    init(midX: CGFloat, y: CGFloat = 0, size: CGSize) {
        self.init(midX: midX, y: y, width: size.width, height: size.height)
    }

    init(midX: CGFloat, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        self.init(x: midX - width / 2, y: y, width: width, height: height)
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

    func rounded() -> CGRect {
        return CGRect(
            x: minX.rounded(),
            y: minY.rounded(),
            maxX: maxX.rounded(),
            maxY: maxY.rounded()
        )
    }

    func inflated() -> CGRect {
        return CGRect(
            x: minX.rounded(.down),
            y: minY.rounded(.down),
            maxX: maxX.rounded(.up),
            maxY: maxY.rounded(.up)
        )
    }

    func slice(at distance: CGFloat, from edge: CGRectEdge) -> CGRect {
        return divided(atDistance: distance, from: edge).slice
    }

    func remainder(at distance: CGFloat, from edge: CGRectEdge) -> CGRect {
        return divided(atDistance: distance, from: edge).remainder
    }

    func inset(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) -> CGRect {
        return UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        ).inset(self)
    }
}

extension CGPath {
    static var empty: CGPath {
        return CGPath(rect: .zero, transform: nil)
    }

    static func between(points: [CGPoint]) -> CGPath {
        let path = CGMutablePath()
        path.addLines(between: points)
        return path
    }

    static func circle(
        center: CGPoint = .zero,
        radius: CGFloat,
        startAngle: CGFloat = 0
    ) -> CGPath {
        let path = CGMutablePath()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: startAngle + 2 * .pi,
            clockwise: false
        )
        path.closeSubpath()
        return path
    }

    static func circleSlice(
        center: CGPoint = .zero,
        radius: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat
    ) -> CGPath {
        let path = CGMutablePath()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        return path
    }

    var bounds: CGRect {
        return boundingBox
    }

    func scaled(x: CGFloat = 1, y: CGFloat = 1) -> CGPath {
        return transformed(with: CGAffineTransform(scaleX: x, y: y))
    }

    func transformed(with transform: CGAffineTransform) -> CGPath {
        var t = transform
        let path = copy(using: &t)
        return path ?? self
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
