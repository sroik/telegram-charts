//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CALayer {
    typealias KeyPath = String

    func presentedValue(for keyPath: KeyPath) -> Any? {
        return presentation()?.value(forKeyPath: keyPath)
    }

    func modelValue(for keyPath: KeyPath) -> Any? {
        return value(forKeyPath: keyPath)
    }

    func basicAnimation(for keyPath: KeyPath) -> CABasicAnimation? {
        return animation(forKey: keyPath) as? CABasicAnimation
    }

    func set(
        value: Any?,
        for keyPath: KeyPath,
        animated: Bool,
        duration: TimeInterval = 1.0
    ) {
        let from = presentedValue(for: keyPath) ?? modelValue(for: keyPath)
        setValue(value, forKeyPath: keyPath)

        if animated, duration > .ulpOfOne {
            animateValue(for: keyPath, from: from, to: value, duration: duration)
        }
    }

    func animateValue(
        for keyPath: KeyPath,
        from: Any?,
        to: Any?,
        duration: TimeInterval
    ) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime()
        removeAnimation(forKey: keyPath)
        add(animation, forKey: keyPath)
    }
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let path = "path"
}
