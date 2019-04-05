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
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = presentedValue(for: keyPath) ?? modelValue(for: keyPath)
        animation.toValue = value
        animation.duration = duration

        removeAnimation(forKey: keyPath)
        setValue(value, forKeyPath: keyPath)

        if animated, duration > .ulpOfOne {
            add(animation, forKey: keyPath)
        }
    }
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let path = "path"
}
