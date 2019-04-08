//
//  Copyright © 2019 sroik. All rights reserved.
//

import UIKit

protocol Updateable {
    var value: Int { get set }
}

typealias UpdateableView = View & Updateable

final class ChartGridAnimator {
    func update(
        _ view: UpdateableView?,
        with value: Int,
        scale: CGFloat,
        animated: Bool
    ) {
        switch scale {
        case -CGFloat.infinity ... 0.5:
            update(view, with: value, translation: -55, animated: animated)
        case 0.5 ... 0.9:
            update(view, with: value, translation: -35, animated: animated)
        case 1.1 ... 1.5:
            update(view, with: value, translation: 35, animated: animated)
        case 1.5 ... CGFloat.infinity:
            update(view, with: value, translation: 55, animated: animated)
        default:
            update(view, with: value, translation: 0, animated: animated)
        }
    }

    func update(
        _ view: UpdateableView?,
        with value: Int,
        translation: CGFloat,
        animated: Bool
    ) {
        guard var view = view, value != view.value else {
            return
        }

        guard animated, let parent = view.superview, !view.bounds.isEmpty else {
            view.value = value
            return
        }

        let snapshot = view.snapshotView
        snapshot.frame = view.frame
        parent.addSubview(snapshot)

        view.value = value
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: translation)

        let animations = {
            snapshot.alpha = 0
            snapshot.transform = CGAffineTransform(translationX: 0, y: -translation)
            view.alpha = 1
            view.transform = .identity
        }

        UIView.animate(withDuration: .smoothDuration, animations: animations) { _ in
            snapshot.removeFromSuperview()
        }
    }
}
