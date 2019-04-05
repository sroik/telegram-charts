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

    func set(
        value: Any?,
        for keyPath: KeyPath,
        animated: Bool,
        duration: TimeInterval = 1.0
    ) {
        let fromValue = presentedValue(for: keyPath) ?? modelValue(for: keyPath)
        removeAnimation(forKey: keyPath)
        setValue(value, forKeyPath: keyPath)

        guard animated, duration > .ulpOfOne else {
            return
        }

        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = value
        animation.duration = duration
        add(animation, forKey: keyPath)
    }
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let path = "path"
}
