//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UIView {
    var isVisible: Bool {
        return !isHidden && alpha > .ulpOfOne
    }

    func fadeIn(
        animated: Bool,
        duration: TimeInterval = .fastDuration,
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
        guard animated else {
            self.alpha = alpha
            return
        }

        UIView.animate(
            withDuration: duration,
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
        guard animated, isVisible else {
            self.frame = frame
            return
        }

        UIView.animate(
            withDuration: duration,
            animations: {
                self.frame = frame
                self.layoutIfNeeded()
            }
        )
    }

    func removeFromSuperview(
        animated: Bool,
        duration: TimeInterval = .fastDuration,
        then completion: Completion? = nil
    ) {
        guard animated else {
            removeFromSuperview()
            return
        }

        UIView.animate(
            withDuration: duration,
            animations: { self.alpha = 0 },
            completion: { _ in
                self.removeFromSuperview()
                completion?()
            }
        )
    }
}

extension UIImageView {
    func set(
        image: UIImage?,
        animated: Bool = true,
        duration: TimeInterval = .defaultDuration
    ) {
        if animated {
            let transition = CATransition()
            transition.duration = duration
            transition.type = .fade
            layer.add(transition, forKey: nil)
        }

        self.image = image
    }
}

extension UILabel {
    func set(
        text: String,
        animated: Bool = true,
        duration: TimeInterval = .defaultDuration
    ) {
        if animated {
            let transition = CATransition()
            transition.duration = duration
            transition.type = .fade
            layer.add(transition, forKey: nil)
        }

        self.text = text
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
