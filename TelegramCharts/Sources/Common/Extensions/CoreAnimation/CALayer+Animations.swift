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
        animation.duration = duration
        animation.timingFunction = timing
        animateValue(for: keyPath, with: animation, from: from, to: to)
    }

    func spring(to value: Any?, for keyPath: KeyPath, animated: Bool) {
        if animated {
            springValue(for: keyPath, to: value)
        } else {
            removeAnimation(forKey: keyPath)
            setValue(value, forKeyPath: keyPath)
        }
    }

    func springValue(for keyPath: KeyPath, to: Any?) {
        return springValue(for: keyPath, from: presentedValue(for: keyPath), to: to)
    }

    func maybeSpringValue(for keyPath: KeyPath, to: Any?) {
        maybeSpringValue(for: keyPath, from: presentedValue(for: keyPath), to: to)
    }

    func springValue(for keyPath: KeyPath, from: Any?, to: Any?) {
        let animation = CABasicAnimation.spring(for: keyPath)
        animateValue(for: keyPath, with: animation, from: from, to: to)
    }

    func maybeSpringValue(for keyPath: KeyPath, from: Any?, to: Any?) {
        let animation = CABasicAnimation.maybeSpring(for: keyPath)
        animateValue(for: keyPath, with: animation, from: from, to: to)
    }

    func animateValue(
        for keyPath: KeyPath,
        with animation: CABasicAnimation,
        from: Any?,
        to: Any?
    ) {
        animation.fromValue = from
        animation.toValue = to
        animation.beginTime = CACurrentMediaTime()
        removeAnimation(forKey: keyPath)
        setValue(to, forKeyPath: keyPath)
        add(animation, forKey: keyPath)
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
        guard scale.isFinite else {
            return
        }

        let height = bounds.height * presentedYScale
        let scaledHeight = bounds.height * scale
        let delta = abs(scaledHeight - height)
        let duration = TimeInterval(delta / velocity).clampedDuration
        set(value: scale, for: .yScale, animated: animated, duration: duration, timing: timing)
    }

    func maybeSpring(to frame: CGRect, animated: Bool) {
        guard animated else {
            self.frame = frame
            removeAnimation(forKey: .bounds)
            removeAnimation(forKey: .position)
            return
        }

        maybeSpringValue(for: .bounds, to: frame.originless)
        maybeSpringValue(for: .position, to: frame.center)
    }

    func spring(to frame: CGRect, animated: Bool) {
        spring(to: frame.originless, for: .bounds, animated: animated)
        spring(to: frame.center, for: .position, animated: animated)
    }

    func spring(to strokeRange: Range<CGFloat>, animated: Bool) {
        spring(to: strokeRange.min, for: .strokeStart, animated: animated)
        spring(to: strokeRange.max, for: .strokeEnd, animated: animated)
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
    static func maybeSpring(for keyPath: CALayer.KeyPath) -> CABasicAnimation {
        if Device.isFast {
            return spring(for: keyPath)
        }

        let animation = CABasicAnimation(keyPath: keyPath)
        animation.timingFunction = .easeInEaseOut
        animation.duration = .smoothDuration
        return animation
    }

    static func spring(for keyPath: CALayer.KeyPath) -> CABasicAnimation {
        let animation = CASpringAnimation(keyPath: keyPath)
        animation.initialVelocity = 10
        animation.damping = 20
        animation.stiffness = 200
        animation.duration = animation.settlingDuration
        return animation
    }
}

extension CAMediaTimingFunction {
    static let linear = CAMediaTimingFunction(name: .linear)
    static let easeInEaseOut = CAMediaTimingFunction(name: .easeInEaseOut)
}
