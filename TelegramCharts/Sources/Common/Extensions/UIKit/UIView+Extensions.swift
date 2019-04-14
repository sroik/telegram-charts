//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

extension UIView {
    var isVisible: Bool {
        return !isHidden && alpha > .ulpOfOne
    }

    static func run(
        animation: @escaping () -> Void,
        animated: Bool,
        duration: TimeInterval = .defaultDuration,
        options: UIView.AnimationOptions = .curveLinear,
        then completion: Completion? = nil
    ) {
        guard animated, duration > .ulpOfOne else {
            animation()
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: animation,
            completion: { isFinished in
                if isFinished {
                    completion?()
                }
            }
        )
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
            options: .curveLinear,
            duration: duration
        )
    }

    func set(
        frame: CGRect,
        animated: Bool = true,
        options: UIView.AnimationOptions = .curveLinear,
        duration: TimeInterval = .fastDuration
    ) {
        guard animated, isVisible else {
            self.frame = frame
            return
        }

        UIView.run(
            animation: { self.frame = frame },
            animated: animated,
            duration: duration,
            options: options
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
