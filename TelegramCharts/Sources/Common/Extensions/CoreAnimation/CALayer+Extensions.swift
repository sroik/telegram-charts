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
        duration: TimeInterval = 0.35,
        timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    ) {
        removeAnimation(forKey: keyPath)
        setValue(value, forKeyPath: keyPath)

        guard duration > .ulpOfOne, animated else {
            return
        }

        let fromValue = presentedValue(for: keyPath) ?? modelValue(for: keyPath)
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = value
        animation.duration = duration
        animation.timingFunction = timingFunction
        add(animation, forKey: keyPath)
    }
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let path = "path"
}
