//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CALayer {
    typealias KeyPath = String

    func presentedValue(for keyPath: KeyPath) -> Any? {
        return presentation()?.value(forKeyPath: keyPath) ?? value(forKeyPath: keyPath)
    }

    func basicAnimation(for keyPath: KeyPath) -> CABasicAnimation? {
        return animation(forKey: keyPath) as? CABasicAnimation
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
}

extension TimeInterval {
    static var defaultDuration: TimeInterval {
        return 0.25
    }
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let path = "path"
}
