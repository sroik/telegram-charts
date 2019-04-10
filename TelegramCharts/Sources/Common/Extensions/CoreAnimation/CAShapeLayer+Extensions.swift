//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    var presentedPath: CGPath? {
        return presentation()?.path ?? path
    }

    var pathAnimation: CABasicAnimation? {
        return basicAnimation(for: .path)
    }

    /**
     * updates column path preserving width.
     * velocity in points per second
     */
    func update(path: CGPath, animated: Bool, velocity: CGFloat = 300) {
        guard let current = presentedPath, !current.bounds.isEmpty else {
            set(path: path, animated: false)
            return
        }

        let deltaMinY = abs(path.bounds.minY - current.bounds.minY)
        let deltaMaxY = abs(path.bounds.maxY - current.bounds.maxY)
        let shift = max(deltaMaxY, deltaMinY)
        let duration = TimeInterval(shift / velocity).clamped(from: 0.2, to: 0.35)

        guard !animated else {
            set(value: path, for: .path, animated: animated, duration: duration)
            return
        }

        guard let animation = pathAnimation else {
            set(value: path, for: .path, animated: false)
            return
        }

        let scaleX = path.bounds.maxX / current.bounds.maxX
        let from = current.scaled(x: scaleX)
        animateValue(for: .path, from: from, to: path, duration: animation.leftTime)
    }

    func set(path: CGPath, animated: Bool, duration: TimeInterval = .defaultDuration) {
        set(value: path, for: .path, animated: animated, duration: duration)
    }
}
