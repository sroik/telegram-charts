//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Cloneable {
    func clone() -> Self
}

typealias CloneableView = Cloneable & UIView

final class ShiftAnimator {
    typealias AnimationBlock<T> = (T) -> Void

    func animate<View: CloneableView>(
        view: View,
        using block: @escaping AnimationBlock<View>,
        shift: CGFloat = 0,
        animated: Bool
    ) {
        guard animated, let parent = view.superview, !view.bounds.isEmpty else {
            block(view)
            return
        }

        guard abs(shift) > .layoutEpsilon else {
            UIView.transition(
                with: view,
                duration: .defaultDuration,
                options: [.transitionCrossDissolve],
                animations: { block(view) },
                completion: nil
            )
            return
        }

        let clone = view.clone()
        clone.frame = view.frame
        parent.addSubview(clone)

        block(view)
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: shift)

        let animations = {
            clone.alpha = 0
            clone.transform = CGAffineTransform(translationX: 0, y: -shift)
            view.alpha = 1
            view.transform = .identity
        }

        UIView.animate(withDuration: .defaultDuration, animations: animations) { _ in
            clone.removeFromSuperview()
        }
    }

    func animate<View: CloneableView>(
        view: View,
        using block: @escaping AnimationBlock<View>,
        scale: CGFloat,
        animated: Bool
    ) {
        animate(
            view: view,
            using: block,
            shift: shift(for: scale),
            animated: animated
        )
    }

    func shift(for scale: CGFloat) -> CGFloat {
        switch scale {
        case -CGFloat.infinity ... 0.5: return -55
        case 1.5 ... CGFloat.infinity: return 55
        case 0.5 ... 0.9: return -35
        case 1.1 ... 1.5: return 35
        default: return 0
        }
    }
}
