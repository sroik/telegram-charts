//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

final class ChartGridAnimator {
    typealias AnimationBlock<T> = (T) -> Void

    func update<View: UIView>(
        _ view: View,
        using block: @escaping AnimationBlock<View>,
        scale: CGFloat,
        animated: Bool
    ) {
        switch scale {
        case -CGFloat.infinity ... 0.5:
            update(view, using: block, translation: -55, animated: animated)
        case 0.5 ... 0.9:
            update(view, using: block, translation: -35, animated: animated)
        case 1.1 ... 1.5:
            update(view, using: block, translation: 35, animated: animated)
        case 1.5 ... CGFloat.infinity:
            update(view, using: block, translation: 55, animated: animated)
        default:
            update(view, using: block, translation: 0, animated: animated)
        }
    }

    func update<View: UIView>(
        _ view: View,
        using block: @escaping AnimationBlock<View>,
        translation: CGFloat,
        animated: Bool
    ) {
        guard animated, let parent = view.superview, !view.bounds.isEmpty else {
            block(view)
            return
        }

        guard abs(translation) > .layoutEpsilon else {
            UIView.transition(
                with: view,
                duration: .defaultDuration,
                options: [.transitionCrossDissolve],
                animations: { block(view) },
                completion: nil
            )
            return
        }

        let snapshot = view.snapshotView
        snapshot.frame = view.frame
        parent.addSubview(snapshot)

        block(view)
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: translation)

        let animations = {
            snapshot.alpha = 0
            snapshot.transform = CGAffineTransform(translationX: 0, y: -translation)
            view.alpha = 1
            view.transform = .identity
        }

        UIView.animate(withDuration: .defaultDuration, animations: animations) { _ in
            snapshot.removeFromSuperview()
        }
    }
}
