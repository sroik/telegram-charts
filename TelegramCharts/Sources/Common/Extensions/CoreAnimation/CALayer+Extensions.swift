//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CALayer {
    typealias KeyPath = String

    static func performWithoutAnimation(_ job: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        job()
        CATransaction.commit()
    }

    func presentedValue(for keyPath: KeyPath) -> Any? {
        return presentation()?.value(forKeyPath: keyPath) ?? value(forKeyPath: keyPath)
    }

    func basicAnimation(for keyPath: KeyPath) -> CABasicAnimation? {
        return animation(forKey: keyPath) as? CABasicAnimation
    }

    func set(frame: CGRect) {
        CALayer.performWithoutAnimation {
            self.frame = frame
        }
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
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let path = "path"
    static let xTranslation = "transform.translation.x"
    static let transform = "transform"
}
