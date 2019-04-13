//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension Column {
    /* step, which is needed to properly display values in rect and vertical range */
    func stride(in rect: CGRect, range: Range<Int>) -> Stride<CGFloat> {
        return Stride(
            x: rect.width / CGFloat(values.count),
            y: rect.height / CGFloat(range.size)
        )
    }

    func notClosePoints(in rect: CGRect, range: Range<Int>) -> [CGPoint] {
        let stride = self.stride(in: rect, range: range)
        var points: [CGPoint] = []
        values.indices.forEach { index in
            let point = self.point(at: index, in: rect, range: range, stride: stride)
            if let last = points.last, last.isClose(to: point) { return }
            points.append(point)
        }

        return points
    }

    func points(in rect: CGRect, range: Range<Int>) -> [CGPoint] {
        let stride = self.stride(in: rect, range: range)
        return values.indices.map { index in
            point(at: index, in: rect, range: range, stride: stride)
        }
    }

    func point(at index: Int, in rect: CGRect, range: Range<Int>) -> CGPoint {
        return point(
            at: index,
            in: rect,
            range: range,
            stride: stride(in: rect, range: range)
        )
    }

    func point(
        at index: Int,
        in rect: CGRect,
        range: Range<Int>,
        stride: Stride<CGFloat>
    ) -> CGPoint {
        guard let value = values[safe: index] else {
            assertionFailureWrapper("invalid index")
            return .zero
        }

        return CGPoint(
            x: rect.minX + (CGFloat(index) + 0.5) * stride.x,
            y: rect.maxY - CGFloat(value - range.min) * stride.y
        )
    }
}
