//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CALayer {
    typealias KeyPath = String

    var presentedYScale: CGFloat {
        return (presentedValue(for: .yScale) as? CGFloat) ?? 1
    }

    func presentedValue(for keyPath: KeyPath) -> Any? {
        return presentation()?.value(forKeyPath: keyPath) ?? value(forKeyPath: keyPath)
    }

    func basicAnimation(for keyPath: KeyPath) -> CABasicAnimation? {
        return animation(forKey: keyPath) as? CABasicAnimation
    }

    func disableActions() {
        actions = [
            kCAOnOrderIn: NSNull(),
            kCAOnOrderOut: NSNull(),
            KeyPath.opacity: NSNull(),
            KeyPath.bounds: NSNull(),
            KeyPath.path: NSNull(),
            KeyPath.position: NSNull(),
            KeyPath.transform: NSNull(),
            KeyPath.backgroundColor: NSNull()
        ]
    }

    func set(
        value: Any?,
        for keyPath: KeyPath,
        animated: Bool,
        duration: TimeInterval = .defaultDuration
    ) {
        guard animated, duration > .ulpOfOne else {
            removeAnimation(forKey: keyPath)
            setValue(value, forKeyPath: keyPath)
            return
        }

        animateValue(
            for: keyPath,
            to: value,
            duration: duration
        )
    }

    func animateValue(for keyPath: KeyPath, to: Any?, duration: TimeInterval) {
        animateValue(
            for: keyPath,
            from: presentedValue(for: keyPath),
            to: to,
            duration: duration
        )
    }

    func animateValue(for keyPath: KeyPath, from: Any?, to: Any?, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
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

    func scale(byY scale: CGFloat, animated: Bool, velocity: CGFloat = 750) {
        let height = bounds.height * presentedYScale
        let scaledHeight = bounds.height * scale
        let delta = abs(scaledHeight - height)
        let duration = TimeInterval(delta / velocity).clampedDuration
        set(value: scale, for: .yScale, animated: animated, duration: duration)
    }

    func set(
        frame: CGRect,
        animated: Bool,
        duration: TimeInterval = .smoothDuration
    ) {
        guard animated, duration > .ulpOfOne else {
            self.frame = frame
            return
        }

        let bounds = CGRect(origin: .zero, size: frame.size)
        let center = CGPoint(x: frame.midX, y: frame.midY)
        set(value: bounds, for: .bounds, animated: animated, duration: duration)
        set(value: center, for: .position, animated: animated, duration: duration)
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

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let position = "position"
    static let bounds = "bounds"
    static let path = "path"
    static let yScale = "transform.scale.y"
    static let xTranslation = "transform.translation.x"
    static let transform = "transform"
    static let backgroundColor = "backgroundColor"
}
