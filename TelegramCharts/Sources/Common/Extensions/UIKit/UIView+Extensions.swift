//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UIView {
    var isVisible: Bool {
        return !isHidden && alpha > .ulpOfOne
    }

    var snapshot: UIImage {
        return snapshot(antialiases: false)
    }

    func snapshot(antialiases: Bool) -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { ctx in
            ctx.cgContext.interpolationQuality = antialiases ? .default : .none
            ctx.cgContext.setAllowsAntialiasing(antialiases)
            layer.render(in: ctx.cgContext)
        }
    }

    func fadeIn(
        animated: Bool,
        duration: TimeInterval = .defaultDuration,
        then completion: Completion? = nil
    ) {
        alpha = 0
        set(alpha: 1, animated: animated, duration: duration, then: completion)
    }

    func set(
        alpha: CGFloat,
        animated: Bool = true,
        duration: TimeInterval = .fastDuration,
        then completion: Completion? = nil
    ) {
        UIView.animate(
            withDuration: animated ? duration : 0,
            animations: { self.alpha = alpha },
            completion: { _ in completion?() }
        )
    }

    func shift(
        to frame: CGRect,
        animated: Bool = true,
        duration: TimeInterval = .fastDuration
    ) {
        set(
            frame: frame,
            animated: animated && frame.intersects(self.frame),
            duration: duration
        )
    }

    func set(
        frame: CGRect,
        animated: Bool = true,
        duration: TimeInterval = .fastDuration
    ) {
        guard animated else {
            self.frame = frame
            return
        }

        UIView.animate(
            withDuration: duration,
            animations: { self.frame = frame }
        )
    }
}

extension UIImageView {
    func set(
        image: UIImage?,
        animated: Bool = true,
        duration: TimeInterval = .defaultDuration
    ) {
        self.image = image

        if animated {
            let transition = CATransition()
            transition.duration = duration
            layer.add(transition, forKey: nil)
        }
    }
}

extension UIStackView {
    var maxIntrinsicWidth: CGFloat {
        return arrangedSubviews
            .map { $0.intrinsicContentSize.width }
            .max() ?? 0
    }
}

extension UIScrollView {
    var visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: bounds.size)
    }
}
