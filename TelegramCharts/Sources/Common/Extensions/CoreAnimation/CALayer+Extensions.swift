//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CALayer {
    typealias KeyPath = String

    func set(
        value: Any?,
        for keyPath: KeyPath,
        animated: Bool,
        duration: TimeInterval = 0.35,
        timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    ) {
        if let keys = animationKeys(), keys.contains(keyPath) {
            removeAnimation(forKey: keyPath)
        }

        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = self.value(forKeyPath: keyPath)
        animation.toValue = value
        animation.duration = duration
        animation.timingFunction = timingFunction
        setValue(value, forKeyPath: keyPath)

        if duration > .ulpOfOne, animated {
            add(animation, forKey: keyPath)
        }
    }
}

extension CALayer.KeyPath {
    static let opacity = "opacity"
    static let path = "path"
}
