//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CALayer {
    func set(
        value: Any?,
        for keyPath: KeyPath,
        animated: Bool,
        duration: TimeInterval = .defaultDuration,
        timing: CAMediaTimingFunction = .linear
    ) {
        guard animated, duration > .ulpOfOne else {
            removeAnimation(forKey: keyPath)
            setValue(value, forKeyPath: keyPath)
            return
        }

        animateValue(
            for: keyPath,
            from: presentedValue(for: keyPath),
            to: value,
            duration: duration,
            timing: timing
        )
    }

    func animateValue(
        for keyPath: KeyPath,
        from: Any?,
        to: Any?,
        duration: TimeInterval,
        timing: CAMediaTimingFunction = .linear
    ) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = timing
        animation.beginTime = CACurrentMediaTime()
        removeAnimation(forKey: keyPath)
        setValue(to, forKeyPath: keyPath)
        add(animation, forKey: keyPath)
    }

    @discardableResult
    func springValue(for keyPath: KeyPath, to: Any?) -> TimeInterval {
        return springValue(for: keyPath, from: presentedValue(for: keyPath), to: to)
    }

    @discardableResult
    func springValue(for keyPath: KeyPath, from: Any?, to: Any?) -> TimeInterval {
        let animation = CABasicAnimation.maybeSpring(for: keyPath)
        animation.fromValue = from
        animation.toValue = to
        removeAnimation(forKey: keyPath)
        setValue(to, forKeyPath: keyPath)
        add(animation, forKey: keyPath)
        return animation.duration
    }

    func blink(scale: CGFloat, duration: TimeInterval = .defaultDuration) {
        let animation = CAKeyframeAnimation(keyPath: .transform)
        let start = transform
        let end = CATransform3DScale(transform, scale, scale, 1)
        animation.values = [start, end, start]
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        removeAnimation(forKey: .transform)
        add(animation, forKey: .transform)
    }

    func shake(duration: TimeInterval = 0.5, translation: CGFloat = 10) {
        let animation = CAKeyframeAnimation(keyPath: .xTranslation)
        animation.duration = duration
        animation.values = [
            -translation, translation,
            -translation / 2, translation / 2,
            -translation / 4, translation / 4,
            0.0
        ]
        removeAnimation(forKey: .xTranslation)
        add(animation, forKey: .xTranslation)
    }

    func scale(
        byY scale: CGFloat,
        animated: Bool,
        velocity: CGFloat = 750,
        timing: CAMediaTimingFunction = .linear
    ) {
        let height = bounds.height * presentedYScale
        let scaledHeight = bounds.height * scale
        let delta = abs(scaledHeight - height)
        let duration = TimeInterval(delta / velocity).clampedDuration

        set(
            value: scale,
            for: .yScale,
            animated: animated,
            duration: duration,
            timing: timing
        )
    }

    @discardableResult
    func spring(to frame: CGRect, animated: Bool) -> TimeInterval {
        guard animated else {
            self.frame = frame
            return 0
        }

        let bounds = springValue(for: .bounds, to: frame.originless)
        let center = springValue(for: .position, to: frame.center)
        return max(center, bounds)
    }
}

extension TimeInterval {
    static var fastDuration: TimeInterval {
        return 0.15
    }

    static var defaultDuration: TimeInterval {
        return 0.25
    }

    static var smoothDuration: TimeInterval {
        return 0.35
    }

    var clampedDuration: TimeInterval {
        return clamped(from: .fastDuration, to: .smoothDuration)
    }
}

extension CABasicAnimation {
    static func maybeSpring(
        for keyPath: CALayer.KeyPath
    ) -> CABasicAnimation {
        guard Device.isFast else {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.timingFunction = .easeInEaseOut
            animation.duration = .smoothDuration
            animation.beginTime = CACurrentMediaTime()
            return animation
        }

        let animation = CASpringAnimation(keyPath: keyPath)
        animation.initialVelocity = 10
        animation.damping = 20
        animation.stiffness = 200
        animation.duration = animation.settlingDuration
        animation.beginTime = CACurrentMediaTime()
        return animation
    }
}

extension CAMediaTimingFunction {
    static var linear: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .linear)
    }

    static var easeInEaseOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeInEaseOut)
    }
}
