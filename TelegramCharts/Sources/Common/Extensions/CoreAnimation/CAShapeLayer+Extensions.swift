//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    var presentedPath: CGPath? {
        return presentation()?.path ?? path
    }

    var pathAnimation: CABasicAnimation? {
        return basicAnimation(for: .path)
    }

    func update(
        path: CGPath,
        preservingAnimations: Bool = true,
        animated: Bool,
        duration: TimeInterval = .smoothDuration
    ) {
        guard !animated || duration < .ulpOfOne else {
            set(value: path, for: .path, animated: animated, duration: duration)
            return
        }

        guard
            preservingAnimations,
            let currentPath = presentedPath,
            let animation = pathAnimation,
            !currentPath.bounds.isEmpty
        else {
            set(value: path, for: .path, animated: false)
            return
        }

        let scale = path.bounds.maxX / currentPath.bounds.maxX
        let from = currentPath.scaled(x: scale)
        let duration = animation.leftTime
        animateValue(for: .path, from: from, to: path, duration: duration)
    }

    func set(path: CGPath, animated: Bool, duration: TimeInterval = .smoothDuration) {
        set(value: path, for: .path, animated: animated, duration: duration)
    }
}
